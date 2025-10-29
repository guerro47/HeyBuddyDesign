# n8n Dockerfile for Railway Deployment
FROM n8nio/n8n:latest

# Set environment variables
ENV N8N_PORT=5678
ENV N8N_PROTOCOL=https
ENV N8N_BASIC_AUTH_ACTIVE=true

# Expose port
EXPOSE 5678

# Start n8n
CMD ["n8n"]
