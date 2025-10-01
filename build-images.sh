#!/bin/bash

# Build script for GFG Microservices Docker images
# Usage: ./build-images.sh [tag] [--no-cache]

set -e

# Default values
TAG=${1:-"latest"}
CACHE_OPTION=""
REGISTRY_PREFIX=${REGISTRY_PREFIX:-"gfg"}

# Check for no-cache flag
if [[ "$*" == *"--no-cache"* ]]; then
    CACHE_OPTION="--no-cache"
    echo "🚫 Building without cache"
fi

echo "🏗️  Building GFG Microservices Docker Images"
echo "📦 Tag: $TAG"
echo "🏭 Registry: $REGISTRY_PREFIX"

# Build parent project first to ensure all dependencies are resolved
echo "🔧 Building parent project..."
mvn clean package -DskipTests -q

# Build Address Service
echo "🏠 Building Address Service..."
docker build $CACHE_OPTION -f address-service/Dockerfile -t $REGISTRY_PREFIX/address-service:$TAG .
docker tag $REGISTRY_PREFIX/address-service:$TAG $REGISTRY_PREFIX/address-service:latest
echo "✅ Address Service built: $REGISTRY_PREFIX/address-service:$TAG"

# Build Employee Service
echo "👥 Building Employee Service..."
docker build $CACHE_OPTION -f employee-service/Dockerfile -t $REGISTRY_PREFIX/employee-service:$TAG .
docker tag $REGISTRY_PREFIX/employee-service:$TAG $REGISTRY_PREFIX/employee-service:latest
echo "✅ Employee Service built: $REGISTRY_PREFIX/employee-service:$TAG"

echo ""
echo "🎉 All images built successfully!"
echo ""
echo "📋 Built Images:"
docker images | grep $REGISTRY_PREFIX | head -4

echo ""
echo "🚀 To run the services:"
echo "   docker-compose up -d"
echo ""
echo "🏷️  To push to registry:"
echo "   docker push $REGISTRY_PREFIX/address-service:$TAG"
echo "   docker push $REGISTRY_PREFIX/employee-service:$TAG"