#!/bin/bash

# Cleanup script for GFG Microservices Docker resources
# Usage: ./cleanup-docker.sh [--all]

set -e

REGISTRY_PREFIX=${REGISTRY_PREFIX:-"gfg"}

echo "🧹 Cleaning up GFG Microservices Docker resources..."

# Stop and remove containers
echo "🛑 Stopping containers..."
docker-compose down --remove-orphans

# Remove images
if [[ "$1" == "--all" ]]; then
    echo "🗑️  Removing all GFG images..."
    docker images | grep $REGISTRY_PREFIX | awk '{print $3}' | xargs -r docker rmi -f
    
    echo "🧽 Removing unused Docker resources..."
    docker system prune -f
    
    echo "💾 Removing volumes..."
    docker volume prune -f
else
    echo "🏷️  Removing latest tags only..."
    docker rmi -f $REGISTRY_PREFIX/address-service:latest 2>/dev/null || echo "   - Address service latest tag not found"
    docker rmi -f $REGISTRY_PREFIX/employee-service:latest 2>/dev/null || echo "   - Employee service latest tag not found"
fi

echo ""
echo "✅ Cleanup completed!"
echo ""
echo "📋 Remaining GFG images:"
docker images | grep $REGISTRY_PREFIX || echo "   - No GFG images found"

echo ""
echo "🔄 To rebuild:"
echo "   ./build-images.sh"