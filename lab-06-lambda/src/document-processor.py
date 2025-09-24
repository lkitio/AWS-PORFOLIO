"""
Chime Bank Customer Onboarding - Document Processor Lambda Function

This Lambda function processes customer documents uploaded during the onboarding process.
It validates document format, extracts metadata, and stores processed information in RDS.
"""

import json
import boto3
import os
import uuid
from datetime import datetime
import logging

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# AWS clients
s3_client = boto3.client('s3')
rds_client = boto3.client('rds-data')
sns_client = boto3.client('sns')

# Environment variables
DATABASE_ARN = os.environ.get('DATABASE_ARN')
SECRET_ARN = os.environ.get('SECRET_ARN')
SNS_TOPIC_ARN = os.environ.get('SNS_TOPIC_ARN')
ALLOWED_DOCUMENT_TYPES = ['application/pdf', 'image/jpeg', 'image/png']
MAX_FILE_SIZE = 10 * 1024 * 1024  # 10MB

def lambda_handler(event, context):
    """
    Main Lambda handler for document processing
    
    Args:
        event: S3 event containing bucket and object information
        context: Lambda context
        
    Returns:
        dict: Response containing processing status
    """
    try:
        logger.info(f"Processing event: {json.dumps(event)}")
        
        # Parse S3 event
        for record in event['Records']:
            bucket_name = record['s3']['bucket']['name']
            object_key = record['s3']['object']['key']
            
            logger.info(f"Processing document: {object_key} from bucket: {bucket_name}")
            
            # Process the document
            result = process_document(bucket_name, object_key)
            
            # Store processing results
            store_document_metadata(result)
            
            # Send notification
            send_processing_notification(result)
            
        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Documents processed successfully',
                'processed_count': len(event['Records'])
            })
        }
        
    except Exception as e:
        logger.error(f"Error processing documents: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({
                'error': 'Failed to process documents',
                'message': str(e)
            })
        }

def process_document(bucket_name, object_key):
    """
    Process individual document from S3
    
    Args:
        bucket_name: S3 bucket name
        object_key: S3 object key
        
    Returns:
        dict: Document processing result
    """
    try:
        # Get document metadata from S3
        response = s3_client.head_object(Bucket=bucket_name, Key=object_key)
        
        document_info = {
            'document_id': str(uuid.uuid4()),
            'bucket_name': bucket_name,
            'object_key': object_key,
            'file_size': response['ContentLength'],
            'content_type': response.get('ContentType', 'unknown'),
            'last_modified': response['LastModified'].isoformat(),
            'processed_at': datetime.utcnow().isoformat(),
            'status': 'processing'
        }
        
        # Validate document
        validation_result = validate_document(document_info)
        document_info.update(validation_result)
        
        if document_info['status'] == 'valid':
            # Extract document metadata
            metadata = extract_document_metadata(bucket_name, object_key)
            document_info.update(metadata)
            
            # Classify document type
            classification = classify_document(document_info)
            document_info.update(classification)
            
            document_info['status'] = 'processed'
            logger.info(f"Document processed successfully: {document_info['document_id']}")
        
        return document_info
        
    except Exception as e:
        logger.error(f"Error processing document {object_key}: {str(e)}")
        return {
            'document_id': str(uuid.uuid4()),
            'bucket_name': bucket_name,
            'object_key': object_key,
            'status': 'error',
            'error_message': str(e),
            'processed_at': datetime.utcnow().isoformat()
        }

def validate_document(document_info):
    """
    Validate document based on size and type constraints
    
    Args:
        document_info: Document information dictionary
        
    Returns:
        dict: Validation result
    """
    validation_result = {
        'validation_errors': []
    }
    
    # Check file size
    if document_info['file_size'] > MAX_FILE_SIZE:
        validation_result['validation_errors'].append(
            f"File size {document_info['file_size']} exceeds maximum allowed size {MAX_FILE_SIZE}"
        )
    
    # Check content type
    if document_info['content_type'] not in ALLOWED_DOCUMENT_TYPES:
        validation_result['validation_errors'].append(
            f"Content type {document_info['content_type']} is not allowed"
        )
    
    # Set validation status
    if validation_result['validation_errors']:
        validation_result['status'] = 'invalid'
        logger.warning(f"Document validation failed: {validation_result['validation_errors']}")
    else:
        validation_result['status'] = 'valid'
        logger.info("Document validation passed")
    
    return validation_result

def extract_document_metadata(bucket_name, object_key):
    """
    Extract metadata from document (placeholder for actual extraction logic)
    
    Args:
        bucket_name: S3 bucket name
        object_key: S3 object key
        
    Returns:
        dict: Extracted metadata
    """
    # This is a placeholder - in real implementation, you would use libraries like:
    # - PyPDF2 for PDF documents
    # - Pillow for image processing
    # - AWS Textract for text extraction
    
    metadata = {
        'extracted_text': '',
        'page_count': 0,
        'image_dimensions': None,
        'document_format': object_key.split('.')[-1].lower()
    }
    
    # Simulate metadata extraction based on file type
    if object_key.lower().endswith('.pdf'):
        metadata.update({
            'page_count': 1,  # Placeholder
            'extracted_text': 'Sample extracted text from PDF'
        })
    elif object_key.lower().endswith(('.jpg', '.jpeg', '.png')):
        metadata.update({
            'image_dimensions': {'width': 1920, 'height': 1080},  # Placeholder
            'extracted_text': 'Sample OCR text from image'
        })
    
    return metadata

def classify_document(document_info):
    """
    Classify document type based on filename and content
    
    Args:
        document_info: Document information dictionary
        
    Returns:
        dict: Classification result
    """
    object_key = document_info['object_key'].lower()
    
    # Simple classification based on filename patterns
    classification = {
        'document_category': 'unknown',
        'confidence_score': 0.0
    }
    
    if 'driver' in object_key or 'license' in object_key:
        classification.update({
            'document_category': 'drivers_license',
            'confidence_score': 0.9
        })
    elif 'passport' in object_key:
        classification.update({
            'document_category': 'passport',
            'confidence_score': 0.9
        })
    elif 'bank' in object_key or 'statement' in object_key:
        classification.update({
            'document_category': 'bank_statement',
            'confidence_score': 0.8
        })
    elif 'utility' in object_key or 'bill' in object_key:
        classification.update({
            'document_category': 'utility_bill',
            'confidence_score': 0.8
        })
    else:
        classification.update({
            'document_category': 'general_document',
            'confidence_score': 0.5
        })
    
    return classification

def store_document_metadata(document_info):
    """
    Store document metadata in RDS database
    
    Args:
        document_info: Document information dictionary
    """
    try:
        # This would typically insert into RDS using RDS Data API
        # For now, we'll just log the information
        logger.info(f"Storing document metadata: {json.dumps(document_info, default=str)}")
        
        # In a real implementation, you would execute SQL like:
        # INSERT INTO customer_documents (document_id, bucket_name, object_key, ...)
        # VALUES (...)
        
    except Exception as e:
        logger.error(f"Error storing document metadata: {str(e)}")
        raise

def send_processing_notification(document_info):
    """
    Send notification about document processing completion
    
    Args:
        document_info: Document information dictionary
    """
    try:
        if not SNS_TOPIC_ARN:
            logger.warning("SNS_TOPIC_ARN not configured, skipping notification")
            return
        
        message = {
            'document_id': document_info['document_id'],
            'status': document_info['status'],
            'object_key': document_info['object_key'],
            'processed_at': document_info['processed_at']
        }
        
        if document_info['status'] == 'error':
            message['error'] = document_info.get('error_message', 'Unknown error')
        
        sns_client.publish(
            TopicArn=SNS_TOPIC_ARN,
            Message=json.dumps(message),
            Subject=f"Document Processing Complete - {document_info['status'].upper()}"
        )
        
        logger.info(f"Notification sent for document: {document_info['document_id']}")
        
    except Exception as e:
        logger.error(f"Error sending notification: {str(e)}")
        # Don't raise exception for notification failures