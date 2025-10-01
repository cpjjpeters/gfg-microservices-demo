# GFG Microservices Demo - Containerization Guide

## ✅ **Containerization Complete!**

This document provides comprehensive information about the Docker containerization of the GFG Microservices Demo project.

## 🚀 **What Was Accomplished**

### 1. **Multi-Stage Dockerfiles Created**
- **address-service/Dockerfile** - Optimized with Eclipse Temurin JDK/JRE
- **employee-service/Dockerfile** - Same optimizations and security practices
- Both use non-root users and container-aware JVM settings

### 2. **Docker Compose Setup**
- **docker-compose.yml** - Complete local development environment
- **MySQL database** with initialization scripts
- **Network configuration** for service communication
- **Health checks** and **dependency management**

### 3. **Build Automation**
- **build-images.sh** - Automated Docker image building script
- **cleanup-docker.sh** - Docker cleanup script
- **Proper tagging** and registry support

### 4. **Project Structure Fixed**
- Created **local AddressResponse DTO** in employee-service for microservice independence
- **Fixed Maven dependencies** to build correctly in containers
- **Added Spring Boot Actuator** for health monitoring

### 5. **Docker Images Built & Tested**
- **Address Service**: ~387MB optimized image
- **Employee Service**: ~490MB optimized image
- **Successfully containerized** and network-connected

## 🛠️ **Usage Commands**

### Quick Start
```bash
# Build all images
./build-images.sh

# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down

# Complete cleanup
./cleanup-docker.sh --all
```

### Advanced Usage
```bash
# Build with specific tag
./build-images.sh v1.0.0

# Build without cache
./build-images.sh latest --no-cache

# View service status
docker-compose ps

# Follow logs for specific service
docker-compose logs -f employee-service

# Restart specific service
docker-compose restart address-service

# Scale services
docker-compose up -d --scale employee-service=2
```

## 🌐 **Service URLs**

| Service | URL | Port | Description |
|---------|-----|------|-------------|
| **Address Service** | http://localhost:8081/address-service | 8081 | Address management API |
| **Employee Service** | http://localhost:8080/employee-service | 8080 | Employee management API |
| **MySQL Database** | localhost:3307 | 3307 | Database (externally accessible) |

### Health Check Endpoints
```bash
# Address Service Health
curl http://localhost:8081/address-service/actuator/health

# Employee Service Health  
curl http://localhost:8080/employee-service/actuator/health
```

## 📁 **Project Structure (Updated)**

```
gfg-microservices-demo/
├── address-service/
│   ├── Dockerfile               # Multi-stage Docker build
│   ├── .dockerignore           # Docker build context optimization
│   ├── src/
│   └── pom.xml
├── employee-service/
│   ├── Dockerfile               # Multi-stage Docker build
│   ├── .dockerignore           # Docker build context optimization
│   ├── src/
│   │   └── main/java/com/gfg/employeaap/dto/
│   │       └── AddressResponse.java  # Local DTO for microservice independence
│   └── pom.xml
├── docker/
│   └── mysql/init/             # Database initialization scripts
│       └── 01-create-databases.sql
├── helm/gfg-microservices/     # Kubernetes Helm charts
├── docker-compose.yml          # Local development environment
├── build-images.sh             # Docker image build script
├── cleanup-docker.sh           # Docker cleanup script
├── WANT-CONTAINER.md           # This documentation
└── README.md                   # Main project documentation
```

## 📦 **Container Features**

### Security & Optimization
- ✅ **Multi-stage builds** for optimal size
- ✅ **Security**: Non-root users, minimal attack surface
- ✅ **Health checks** with Spring Boot Actuator
- ✅ **Environment-based configuration**
- ✅ **Production-ready** JVM optimizations

### Base Images
- **Build Stage**: `eclipse-temurin:17-jdk`
- **Runtime Stage**: `eclipse-temurin:17-jre`

### JVM Optimizations
```bash
JAVA_OPTS="-XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0 -Djava.security.egd=file:/dev/./urandom"
```

### Image Sizes
- **Address Service**: ~387MB
- **Employee Service**: ~490MB

## 🐳 **Docker Configuration Details**

### Environment Variables

#### Common Variables
| Variable | Default | Description |
|----------|---------|-------------|
| `SPRING_APPLICATION_NAME` | service-name | Application name |
| `SERVER_PORT` | 8080/8081 | HTTP port |
| `SERVER_SERVLET_CONTEXT_PATH` | /service-name | Context path |
| `SPRING_DATASOURCE_URL` | - | Database URL |
| `SPRING_DATASOURCE_USERNAME` | root | Database username |
| `SPRING_DATASOURCE_PASSWORD` | - | Database password |
| `SPRING_JPA_HIBERNATE_DDL_AUTO` | update | Hibernate DDL mode |

#### Employee Service Specific
| Variable | Default | Description |
|----------|---------|-------------|
| `MICROSERVICES_ADDRESS_SERVICE_URL` | http://address-service:8081/address-service | Address service URL |
| `SPRING_JPA_SHOW_SQL` | false | Show SQL queries |
| `LOGGING_LEVEL_COM_GFG_EMPLOYEAPP` | INFO | Logging level |

### Network Configuration
- **Network Name**: `gfg-network`
- **Network Driver**: `bridge`
- **Service Discovery**: DNS-based (service names as hostnames)

### Volume Configuration
- **MySQL Data**: `mysql_data` persistent volume
- **Database Initialization**: `./docker/mysql/init:/docker-entrypoint-initdb.d`

## 🔧 **Build Process**

### Manual Docker Build
```bash
# Build from project root (important!)
docker build -f address-service/Dockerfile -t gfg/address-service:latest .
docker build -f employee-service/Dockerfile -t gfg/employee-service:latest .
```

### Build Script Features
- Automated Maven build before Docker build
- Proper tagging (both specific tag and latest)
- Build time reporting
- Error handling
- Registry prefix support

### Build Script Environment Variables
```bash
export REGISTRY_PREFIX=your-registry.com/gfg  # Custom registry
./build-images.sh v1.0.0
```

## 🗃️ **Database Configuration**

### MySQL Setup
- **Version**: MySQL 8.0
- **Root Password**: MySqlR00t
- **Databases**: 
  - `gfgmicroservicesdemo` (Address Service)
  - `employeedb` (Employee Service)
- **External Port**: 3307 (to avoid conflicts)
- **Internal Port**: 3306

### Database Initialization
The `docker/mysql/init/01-create-databases.sql` script automatically:
- Creates required databases
- Sets up user permissions
- Ensures proper isolation between services

## 🔍 **Troubleshooting**

### Common Issues

#### Port Conflicts
```bash
# If ports are already in use, modify docker-compose.yml
ports:
  - "8082:8081"  # Address service on different port
```

#### Health Check Failures
```bash
# Check application logs
docker-compose logs address-service

# Test health endpoint manually
curl http://localhost:8081/address-service/actuator/health
```

#### Build Failures
```bash
# Clean rebuild
./cleanup-docker.sh --all
./build-images.sh --no-cache
```

#### Database Connection Issues
```bash
# Check MySQL status
docker-compose logs mysql

# Verify network connectivity
docker-compose exec address-service ping mysql
```

### Debugging Commands
```bash
# Enter running container
docker-compose exec address-service /bin/bash

# Check environment variables
docker-compose exec address-service env | grep SPRING

# View container resource usage
docker stats gfg-address-service gfg-employee-service
```

## 🚀 **Production Deployment**

### Container Registry
```bash
# Tag for registry
docker tag gfg/address-service:latest your-registry.com/gfg/address-service:v1.0.0
docker tag gfg/employee-service:latest your-registry.com/gfg/employee-service:v1.0.0

# Push to registry
docker push your-registry.com/gfg/address-service:v1.0.0
docker push your-registry.com/gfg/employee-service:v1.0.0
```

### Kubernetes Deployment
The project includes Helm charts in `helm/gfg-microservices/`:
```bash
# Deploy to Kubernetes
helm install gfg-microservices ./helm/gfg-microservices \
  --set addressService.image.repository=your-registry.com/gfg/address-service \
  --set employeeService.image.repository=your-registry.com/gfg/employee-service
```

### Security Considerations
1. **Use specific image tags** in production (avoid `latest`)
2. **Scan images** for vulnerabilities: `docker scan gfg/address-service:v1.0.0`
3. **Use secrets management** for database passwords
4. **Configure resource limits** in production
5. **Enable security contexts** in Kubernetes

## 📊 **Performance Optimization**

### JVM Tuning
The containers are configured with container-aware JVM settings:
- `-XX:+UseContainerSupport` - Container memory detection
- `-XX:MaxRAMPercentage=75.0` - Use 75% of container memory
- `-Djava.security.egd=file:/dev/./urandom` - Faster startup

### Resource Recommendations
```yaml
resources:
  requests:
    memory: "512Mi"
    cpu: "250m"
  limits:
    memory: "1Gi"
    cpu: "500m"
```

## 🎯 **Ready For**

- ✅ **Local development** with Docker Compose
- ✅ **Kubernetes deployment** with existing Helm charts  
- ✅ **Container registry** deployment
- ✅ **CI/CD pipeline** integration
- ✅ **Production scaling** and monitoring
- ✅ **Multi-environment** deployment (dev, test, prod)

## 📞 **Support & Maintenance**

### Regular Maintenance Tasks
```bash
# Update base images periodically
docker pull eclipse-temurin:17-jdk
docker pull eclipse-temurin:17-jre

# Clean up unused resources
docker system prune -a

# Update dependencies
mvn versions:display-dependency-updates
```

### Monitoring
- Health endpoints available at `/actuator/health`
- Metrics available at `/actuator/metrics`
- Application info at `/actuator/info`

---

**Created**: October 1, 2025  
**Status**: ✅ Production Ready  
**Version**: v1.0.0  

Your microservices are now fully containerized and ready for modern deployment patterns! 🎉