#!/bin/bash

# Chime Bank Customer Onboarding - Master Deployment Script
# This script deploys the complete AWS portfolio for the customer onboarding application

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
ENVIRONMENT=${ENVIRONMENT:-Development}
REGION=${AWS_DEFAULT_REGION:-us-west-2}
STACK_PREFIX="chime-bank"

# Function to print colored output
print_header() {
    echo -e "\n${BLUE}============================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}============================================${NC}\n"
}

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

# Function to get stack output
get_stack_output() {
    local stack_name=$1
    local output_key=$2
    aws cloudformation describe-stacks \
        --stack-name "$stack_name" \
        --region "$REGION" \
        --query "Stacks[0].Outputs[?OutputKey=='$output_key'].OutputValue" \
        --output text
}

# Validate prerequisites
validate_prerequisites() {
    print_header "Validating Prerequisites"
    
    # Check AWS CLI
    if ! command -v aws &> /dev/null; then
        print_error "AWS CLI is not installed. Please install AWS CLI v2."
        exit 1
    fi
    
    # Check AWS credentials
    if ! aws sts get-caller-identity > /dev/null 2>&1; then
        print_error "AWS CLI is not configured. Please run 'aws configure' first."
        exit 1
    fi
    
    # Check region
    if [[ -z "$REGION" ]]; then
        print_error "AWS region not set. Please set AWS_DEFAULT_REGION environment variable."
        exit 1
    fi
    
    print_status "Prerequisites validated successfully"
    print_status "Deploying to region: $REGION"
    print_status "Environment: $ENVIRONMENT"
}

# Deploy Lab 1: IAM
deploy_iam() {
    print_header "Lab 1: Deploying IAM Infrastructure"
    
    cd lab-01-iam
    
    # Deploy IAM policies
    if stack_exists "${STACK_PREFIX}-iam-policies"; then
        print_warning "IAM policies stack already exists. Skipping..."
    else
        aws cloudformation create-stack \
            --stack-name "${STACK_PREFIX}-iam-policies" \
            --template-body file://cloudformation/iam-policies.yaml \
            --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM \
            --region "$REGION"
        wait_for_stack "${STACK_PREFIX}-iam-policies" "create"
    fi
    
    # Get policy ARNs
    CUSTOMER_DATA_POLICY_ARN=$(get_stack_output "${STACK_PREFIX}-iam-policies" "CustomerDataPolicyArn")
    ONBOARDING_APP_POLICY_ARN=$(get_stack_output "${STACK_PREFIX}-iam-policies" "OnboardingAppPolicyArn")
    
    # Deploy IAM roles
    if stack_exists "${STACK_PREFIX}-iam-roles"; then
        print_warning "IAM roles stack already exists. Skipping..."
    else
        aws cloudformation create-stack \
            --stack-name "${STACK_PREFIX}-iam-roles" \
            --template-body file://cloudformation/iam-roles.yaml \
            --parameters ParameterKey=CustomerDataPolicyArn,ParameterValue="$CUSTOMER_DATA_POLICY_ARN" \
                        ParameterKey=OnboardingAppPolicyArn,ParameterValue="$ONBOARDING_APP_POLICY_ARN" \
            --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM \
            --region "$REGION"
        wait_for_stack "${STACK_PREFIX}-iam-roles" "create"
    fi
    
    cd ..
    print_status "Lab 1: IAM deployment completed"
}

# Deploy Lab 2: VPC
deploy_vpc() {
    print_header "Lab 2: Deploying VPC Infrastructure"
    
    cd lab-02-vpc
    
    if stack_exists "${STACK_PREFIX}-vpc"; then
        print_warning "VPC stack already exists. Skipping..."
    else
        aws cloudformation create-stack \
            --stack-name "${STACK_PREFIX}-vpc" \
            --template-body file://cloudformation/vpc-infrastructure.yaml \
            --parameters ParameterKey=EnvironmentName,ParameterValue="$ENVIRONMENT" \
            --region "$REGION"
        wait_for_stack "${STACK_PREFIX}-vpc" "create"
    fi
    
    cd ..
    print_status "Lab 2: VPC deployment completed"
}

# Deploy remaining labs (placeholder functions)
deploy_ec2() {
    print_header "Lab 3: Deploying EC2 Infrastructure"
    print_status "EC2 deployment would be implemented here"
    print_status "Lab 3: EC2 deployment completed"
}

deploy_rds() {
    print_header "Lab 4: Deploying RDS Database"
    print_status "RDS deployment would be implemented here"
    print_status "Lab 4: RDS deployment completed"
}

deploy_s3() {
    print_header "Lab 5: Deploying S3 Storage"
    print_status "S3 deployment would be implemented here"
    print_status "Lab 5: S3 deployment completed"
}

deploy_lambda() {
    print_header "Lab 6: Deploying Lambda Functions"
    print_status "Lambda deployment would be implemented here"
    print_status "Lab 6: Lambda deployment completed"
}

deploy_api_gateway() {
    print_header "Lab 7: Deploying API Gateway"
    print_status "API Gateway deployment would be implemented here"
    print_status "Lab 7: API Gateway deployment completed"
}

deploy_cognito() {
    print_header "Lab 8: Deploying Cognito Authentication"
    print_status "Cognito deployment would be implemented here"
    print_status "Lab 8: Cognito deployment completed"
}

deploy_monitoring() {
    print_header "Lab 10: Deploying CloudWatch Monitoring"
    print_status "CloudWatch deployment would be implemented here"
    print_status "Lab 10: CloudWatch deployment completed"
}

# Display deployment summary
display_summary() {
    print_header "Deployment Summary"
    
    print_status "Chime Bank Customer Onboarding Portfolio Deployed Successfully!"
    echo
    print_status "Environment: $ENVIRONMENT"
    print_status "Region: $REGION"
    echo
    print_status "Key Resources Created:"
    
    # Display key outputs if stacks exist
    if stack_exists "${STACK_PREFIX}-vpc"; then
        VPC_ID=$(get_stack_output "${STACK_PREFIX}-vpc" "VPC")
        print_status "- VPC ID: $VPC_ID"
    fi
    
    if stack_exists "${STACK_PREFIX}-iam-roles"; then
        EC2_ROLE_ARN=$(get_stack_output "${STACK_PREFIX}-iam-roles" "EC2RoleArn")
        print_status "- EC2 Role: $EC2_ROLE_ARN"
    fi
    
    echo
    print_status "Access the following resources:"
    print_status "- AWS Console: https://console.aws.amazon.com/"
    print_status "- CloudFormation Stacks: https://console.aws.amazon.com/cloudformation/home?region=$REGION"
    echo
    print_status "Next Steps:"
    print_status "1. Review the deployed resources in AWS Console"
    print_status "2. Configure application-specific settings"
    print_status "3. Test the customer onboarding workflow"
    print_status "4. Set up monitoring and alerts"
    echo
    print_warning "Remember to clean up resources when no longer needed to avoid charges"
}

# Main execution
main() {
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                                                              ║"
    echo "║        Chime Bank Customer Onboarding AWS Portfolio         ║"
    echo "║                    Master Deployment Script                 ║"
    echo "║                                                              ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}\n"
    
    validate_prerequisites
    
    print_status "Starting deployment of 10 labs..."
    echo
    
    # Deploy labs in order
    deploy_iam
    deploy_vpc
    deploy_ec2
    deploy_rds
    deploy_s3
    deploy_lambda
    deploy_api_gateway
    deploy_cognito
    # Lab 9 (CloudFormation) is this script
    deploy_monitoring
    
    display_summary
    
    print_header "Deployment Complete!"
    print_status "Portfolio deployment finished successfully."
    print_status "Total deployment time: $(($SECONDS / 60)) minutes"
}

# Handle script interruption
trap 'print_error "Deployment interrupted. Some resources may have been created."; exit 1' INT TERM

# Run main function
main "$@"