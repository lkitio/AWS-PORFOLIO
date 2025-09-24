#!/bin/bash

# Chime Bank Customer Onboarding - IAM Setup Script
# This script deploys the IAM infrastructure for the customer onboarding application

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
STACK_PREFIX="chime-bank-iam"
REGION="us-west-2"

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if stack exists
stack_exists() {
    aws cloudformation describe-stacks --stack-name "$1" --region "$REGION" > /dev/null 2>&1
}

# Function to wait for stack completion
wait_for_stack() {
    local stack_name=$1
    local action=$2
    print_status "Waiting for stack $stack_name to complete $action..."
    aws cloudformation wait stack-${action}-complete --stack-name "$stack_name" --region "$REGION"
    if [ $? -eq 0 ]; then
        print_status "Stack $stack_name $action completed successfully"
    else
        print_error "Stack $stack_name $action failed"
        exit 1
    fi
}

# Main execution
main() {
    print_status "Starting Chime Bank IAM infrastructure deployment..."
    
    # Check AWS CLI configuration
    if ! aws sts get-caller-identity > /dev/null 2>&1; then
        print_error "AWS CLI is not configured. Please run 'aws configure' first."
        exit 1
    fi
    
    print_status "AWS CLI is configured. Proceeding with deployment..."
    
    # Deploy IAM Policies
    print_status "Deploying IAM Policies..."
    if stack_exists "${STACK_PREFIX}-policies"; then
        print_warning "Stack ${STACK_PREFIX}-policies already exists. Updating..."
        aws cloudformation update-stack \
            --stack-name "${STACK_PREFIX}-policies" \
            --template-body file://cloudformation/iam-policies.yaml \
            --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM \
            --region "$REGION"
        wait_for_stack "${STACK_PREFIX}-policies" "update"
    else
        aws cloudformation create-stack \
            --stack-name "${STACK_PREFIX}-policies" \
            --template-body file://cloudformation/iam-policies.yaml \
            --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM \
            --region "$REGION"
        wait_for_stack "${STACK_PREFIX}-policies" "create"
    fi
    
    # Get policy ARNs from the first stack
    CUSTOMER_DATA_POLICY_ARN=$(aws cloudformation describe-stacks \
        --stack-name "${STACK_PREFIX}-policies" \
        --region "$REGION" \
        --query 'Stacks[0].Outputs[?OutputKey==`CustomerDataPolicyArn`].OutputValue' \
        --output text)
    
    ONBOARDING_APP_POLICY_ARN=$(aws cloudformation describe-stacks \
        --stack-name "${STACK_PREFIX}-policies" \
        --region "$REGION" \
        --query 'Stacks[0].Outputs[?OutputKey==`OnboardingAppPolicyArn`].OutputValue' \
        --output text)
    
    # Deploy IAM Roles
    print_status "Deploying IAM Roles..."
    if stack_exists "${STACK_PREFIX}-roles"; then
        print_warning "Stack ${STACK_PREFIX}-roles already exists. Updating..."
        aws cloudformation update-stack \
            --stack-name "${STACK_PREFIX}-roles" \
            --template-body file://cloudformation/iam-roles.yaml \
            --parameters ParameterKey=CustomerDataPolicyArn,ParameterValue="$CUSTOMER_DATA_POLICY_ARN" \
                        ParameterKey=OnboardingAppPolicyArn,ParameterValue="$ONBOARDING_APP_POLICY_ARN" \
            --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM \
            --region "$REGION"
        wait_for_stack "${STACK_PREFIX}-roles" "update"
    else
        aws cloudformation create-stack \
            --stack-name "${STACK_PREFIX}-roles" \
            --template-body file://cloudformation/iam-roles.yaml \
            --parameters ParameterKey=CustomerDataPolicyArn,ParameterValue="$CUSTOMER_DATA_POLICY_ARN" \
                        ParameterKey=OnboardingAppPolicyArn,ParameterValue="$ONBOARDING_APP_POLICY_ARN" \
            --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM \
            --region "$REGION"
        wait_for_stack "${STACK_PREFIX}-roles" "create"
    fi
    
    print_status "Deployment completed successfully!"
    print_status "Stack outputs:"
    
    # Display important outputs
    aws cloudformation describe-stacks \
        --stack-name "${STACK_PREFIX}-roles" \
        --region "$REGION" \
        --query 'Stacks[0].Outputs[*].[OutputKey,OutputValue]' \
        --output table
}

# Run main function
main "$@"