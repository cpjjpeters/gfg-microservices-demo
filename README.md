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

## Next Steps for Development

1. **Port Configuration**: Configure different ports for each service to avoid conflicts
2. **Service Communication**: Implement RestTemplate for inter-service communication
3. **Database Setup**: Configure separate databases for each service
4. **API Gateway**: Consider adding an API Gateway for routing
5. **Service Discovery**: Implement service discovery (Eureka) for production

## Contributing

1. Make changes to individual services in their respective directories
2. Build and test locally using `mvn clean install`
3. Ensure all modules build successfully from the root
4. Test service communication and endpoints
5. Update documentation as needed
