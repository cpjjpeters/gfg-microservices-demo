# GFG Microservices Demo
Reference: https://www.geeksforgeeks.org/java/spring-boot-microservices-communication-using-resttemplate-with-example/

This is a multi-module Maven project demonstrating microservices architecture with Spring Boot, created by combining the existing address-service and employee-service projects.

## Project Structure

```
gfg-microservices-demo/
├── address-service/          # Address management microservice
├── employee-service/         # Employee management microservice
├── pom.xml                  # Parent POM file
└── README.md
```

## Modules

### Address Service
- **Port:** 8081
- **Description:** Manages address-related operations
- **Database:** MySQL
- **Key Dependencies:** Spring Boot Web, Spring Data JPA, ModelMapper

### Employee Service  
- **Port:** 8080
- **Description:** Manages employee-related operations
- **Database:** MySQL/H2
- **Key Dependencies:** Spring Boot Web, Spring Data JPA, ModelMapper

## Getting Started

### Prerequisites
- Java 17
- Maven 3.6+
- MySQL (or H2 for testing)

### Building the Project
```bash
# Build all modules
mvn clean install

# Build specific module
mvn clean install -pl address-service
mvn clean install -pl employee-service
```

### Running the Services

#### Address Service
```bash
cd address-service
mvn spring-boot:run
```

#### Employee Service  
```bash
cd employee-service
mvn spring-boot:run
```

**Note:** The services are already configured with different ports to avoid conflicts. Current port configuration in `application.properties` files:

```properties
# address-service/src/main/resources/application.properties
server.port=8081

# employee-service/src/main/resources/application.properties
server.port=8080
```

## Configuration

Each service has its own configuration files in their respective `src/main/resources` directories:
- `application.properties` - Main configuration
- Database configuration for MySQL/H2

## Development

This project follows microservices patterns:
- Each service is independently deployable
- Separate databases per service
- RESTful APIs for communication
- Shared dependencies managed at parent level

## Project Creation Details

### ✅ What Was Accomplished

This project was created by combining two existing Spring Boot projects into a unified multi-module Maven structure:

1. **Source Projects:**
   - `address-service` - Copied from `/Users/carlpeters/IdeaProjects/address-service`
   - `employee-service` - Copied from `/Users/carlpeters/IdeaProjects/employeaap`

2. **Multi-Module Setup:**
   - Created parent `pom.xml` with Spring Boot 3.1.5 and Java 17
   - Configured both services as Maven modules
   - Updated child POMs to reference the parent project
   - Centralized dependency management (e.g., ModelMapper version)

3. **Project Structure:**
   ```
   gfg-microservices-demo/
   ├── address-service/          # Address management microservice
   ├── employee-service/         # Employee management microservice  
   ├── pom.xml                  # Parent Maven POM
   └── README.md                # This documentation
   ```

4. **Build Verification:**
   - Successfully compiled with `mvn clean compile`
   - Reactor build order: Parent → Address Service → Employee Service
   - All modules build without errors

### Key Features Implemented:

- **Multi-Module Maven Setup**: Parent POM manages both services as modules
- **Proper Parent-Child Relationships**: Child POMs reference parent for dependency management
- **Dependency Management**: Common dependencies centralized in parent POM
- **Consistent Configuration**: Both services use Java 17 and Spring Boot 3.1.5
- **Independent Deployability**: Each service can be built and run independently
- **Comprehensive Documentation**: Detailed README with build and run instructions

### Original Project Configurations:

#### Address Service (from `/Users/carlpeters/IdeaProjects/address-service`)
- Group ID: `com.gfg.addressapp` (updated to `com.gfg` in multi-module)
- Dependencies: Spring Boot Web, Spring Data JPA, MySQL Connector, ModelMapper, DevTools
- Database: MySQL

#### Employee Service (from `/Users/carlpeters/IdeaProjects/employeaap`)
- Group ID: `com.gfg`
- Dependencies: Spring Boot Web, Spring Data JPA, MySQL Connector, H2, ModelMapper, DevTools  
- Database: MySQL/H2

### Build Commands Used:

```bash
# Create project directory
mkdir -p ~/IdeaProjects/gfg-microservices-demo

# Copy services
cp -r ~/IdeaProjects/address-service ~/IdeaProjects/gfg-microservices-demo/
cp -r ~/IdeaProjects/employeaap ~/IdeaProjects/gfg-microservices-demo/employee-service

# Verify build
cd ~/IdeaProjects/gfg-microservices-demo
mvn clean compile
```

## Helm Configuration

### ✅ Environment-Specific Configuration

The project now includes Helm charts for deploying to different environments (dev, tst, prod) with configurable URLs.

#### Key Configuration Change

**Before (Hardcoded):**
```java
// Line 31 in EmployeeService.java
AddressResponse addressResponse = restTemplate.getForObject(
    "http://localhost:8081/address-service/address/{id}", 
    AddressResponse.class, id);
```

**After (Configurable):**
```java
// EmployeeService.java with @Value annotation
@Value("${microservices.address-service.url}")
private String addressServiceUrl;

// Usage in method
AddressResponse addressResponse = restTemplate.getForObject(
    addressServiceUrl + "/address/{id}", 
    AddressResponse.class, id);
```

#### Helm Chart Structure
```
helm/gfg-microservices/
├── Chart.yaml                    # Chart metadata
├── values.yaml                  # Default values
├── values-dev.yaml              # Development environment values
├── values-tst.yaml              # Test environment values
└── templates/
    ├── _helpers.tpl             # Template helpers
    ├── address-service-deployment.yaml
    ├── address-service-service.yaml
    ├── employee-service-deployment.yaml
    └── employee-service-service.yaml
```

#### Environment-Specific URLs

| Environment | Address Service URL |
|-------------|--------------------|
| **Local Development** | `http://localhost:8081/address-service` |
| **Dev** | `http://address-service-dev:8081/address-service` |
| **Test** | `http://address-service-tst:8081/address-service` |
| **Production** | `http://address-service-prod:8081/address-service` |

#### Deployment Commands

```bash
# Deploy to development
helm install gfg-microservices-dev ./helm/gfg-microservices \
  -f ./helm/gfg-microservices/values-dev.yaml

# Deploy to test
helm install gfg-microservices-tst ./helm/gfg-microservices \
  -f ./helm/gfg-microservices/values-tst.yaml

# Deploy to production with custom values
helm install gfg-microservices-prod ./helm/gfg-microservices \
  --set employeeService.config.microservices.addressServiceUrl=http://address-service-prod:8081/address-service

# Upgrade existing deployment
helm upgrade gfg-microservices-dev ./helm/gfg-microservices \
  -f ./helm/gfg-microservices/values-dev.yaml
```

#### Configuration Properties

The `microservices.address-service.url` property can be configured in multiple ways:

1. **application.properties** (default for local development):
   ```properties
   microservices.address-service.url=http://localhost:8081/address-service
   ```

2. **Environment Variables** (Kubernetes deployment):
   ```yaml
   env:
     - name: MICROSERVICES_ADDRESS_SERVICE_URL
       value: http://address-service-dev:8081/address-service
   ```

3. **Helm Values** (values-dev.yaml, values-tst.yaml):
   ```yaml
   employeeService:
     config:
       microservices:
         addressServiceUrl: http://address-service-dev:8081/address-service
   ```

## Docker Containerization

### ✅ Containerized Services

Both microservices are now fully containerized with Docker support for development and production deployments.

#### Container Features

- **Multi-stage builds**: Optimized image size with separate build and runtime stages
- **Non-root user**: Security best practices with dedicated app user
- **Health checks**: Built-in health monitoring for both services
- **JVM optimization**: Container-aware JVM settings for optimal performance
- **Environment configuration**: Fully configurable via environment variables

#### Project Structure (Updated)
```
gfg-microservices-demo/
├── address-service/
│   ├── Dockerfile               # Multi-stage Docker build
│   ├── .dockerignore           # Docker build context optimization
│   └── src/...
├── employee-service/
│   ├── Dockerfile               # Multi-stage Docker build
│   ├── .dockerignore           # Docker build context optimization
│   └── src/...
├── docker/
│   └── mysql/init/             # Database initialization scripts
├── helm/gfg-microservices/     # Kubernetes Helm charts
├── docker-compose.yml          # Local development environment
├── build-images.sh             # Docker image build script
└── cleanup-docker.sh           # Docker cleanup script
```

### Quick Start with Docker

#### Option 1: Docker Compose (Recommended for Development)
```bash
# Start all services with MySQL database
docker-compose up -d

# View logs
docker-compose logs -f

# Stop all services
docker-compose down
```

#### Option 2: Build and Run Individual Services
```bash
# Build all images
./build-images.sh

# Or build with specific tag
./build-images.sh v1.0.0

# Or build without cache
./build-images.sh latest --no-cache
```

### Docker Commands

#### Building Images
```bash
# Build both services (automated script)
./build-images.sh [tag] [--no-cache]

# Manual build - Address Service
cd address-service
docker build -t gfg/address-service:latest .

# Manual build - Employee Service
cd employee-service
docker build -t gfg/employee-service:latest .
```

#### Running Containers
```bash
# Using Docker Compose (recommended)
docker-compose up -d

# Manual run with network
docker network create gfg-network

# Run MySQL
docker run -d --name gfg-mysql --network gfg-network \
  -e MYSQL_ROOT_PASSWORD=MySqlR00t \
  -e MYSQL_DATABASE=gfgmicroservicesdemo \
  -p 3306:3306 mysql:8.0

# Run Address Service
docker run -d --name gfg-address-service --network gfg-network \
  -e SPRING_DATASOURCE_URL=jdbc:mysql://gfg-mysql:3306/gfgmicroservicesdemo \
  -p 8081:8081 gfg/address-service:latest

# Run Employee Service
docker run -d --name gfg-employee-service --network gfg-network \
  -e SPRING_DATASOURCE_URL=jdbc:mysql://gfg-mysql:3306/employeedb \
  -e MICROSERVICES_ADDRESS_SERVICE_URL=http://gfg-address-service:8081/address-service \
  -p 8080:8080 gfg/employee-service:latest
```

#### Container Management
```bash
# View running containers
docker-compose ps

# View logs
docker-compose logs -f [service-name]
docker-compose logs -f employee-service

# Restart specific service
docker-compose restart employee-service

# Scale services (if needed)
docker-compose up -d --scale employee-service=2
```

#### Cleanup
```bash
# Stop and remove containers, but keep images
./cleanup-docker.sh

# Complete cleanup (removes images and volumes)
./cleanup-docker.sh --all

# Manual cleanup
docker-compose down -v --remove-orphans
```

### Environment Variables

Both services support the following environment variables:

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
| `MICROSERVICES_ADDRESS_SERVICE_URL` | - | Address service URL |
| `SPRING_JPA_SHOW_SQL` | false | Show SQL queries |
| `LOGGING_LEVEL_COM_GFG_EMPLOYEAPP` | INFO | Logging level |

### Docker Image Details

#### Base Images
- **Build Stage**: `openjdk:17-jdk-slim`
- **Runtime Stage**: `openjdk:17-jre-slim`

#### Optimizations
- Multi-stage builds for smaller runtime images
- Non-root user for security
- Container-aware JVM settings (`-XX:+UseContainerSupport`)
- Memory optimization (`-XX:MaxRAMPercentage=75.0`)
- Health checks for service monitoring
- Proper signal handling for graceful shutdown

#### Image Sizes (Approximate)
- Address Service: ~280MB
- Employee Service: ~285MB

### Testing Containerized Services

```bash
# Start services
docker-compose up -d

# Wait for services to be healthy
docker-compose ps

# Test Address Service
curl http://localhost:8081/address-service/actuator/health

# Test Employee Service
curl http://localhost:8080/employee-service/actuator/health

# Test service communication (if you have test endpoints)
curl http://localhost:8080/employee-service/employees/1
```

### Production Considerations

1. **Registry**: Tag and push images to a container registry
   ```bash
   docker tag gfg/address-service:latest your-registry.com/gfg/address-service:v1.0.0
   docker push your-registry.com/gfg/address-service:v1.0.0
   ```

2. **Security**: Use specific versions, scan for vulnerabilities
   ```bash
   docker scan gfg/address-service:latest
   ```

3. **Monitoring**: Use proper monitoring and logging solutions

4. **Secrets**: Use proper secret management for passwords

## Next Steps for Development

1. **✅ Container Images**: Docker images created and tested
2. **Service Communication**: Test RestTemplate communication between containerized services
3. **Container Registry**: Set up container registry for production images
4. **Kubernetes Deployment**: Use Helm charts for Kubernetes deployment
5. **Monitoring**: Add monitoring stack (Prometheus, Grafana)
6. **Security Scanning**: Implement container security scanning

## Contributing

1. Make changes to individual services in their respective directories
2. Build and test locally using `mvn clean install`
3. Ensure all modules build successfully from the root
4. Test service communication and endpoints
5. Update documentation as needed
