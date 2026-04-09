# CloudHub Deployment Guide

This guide provides comprehensive instructions for deploying the MuleSoft application to CloudHub using various methods.

## Prerequisites

1. **Anypoint Platform Account**: Valid credentials with CloudHub deployment permissions
2. **Maven 3.6+**: Installed and configured
3. **Java 17**: Required for Mule 4.11.2
4. **Git**: For version control and CI/CD

## Deployment Methods

### Method 1: CI/CD Pipeline (Recommended)

The application includes a complete GitHub Actions CI/CD pipeline that automatically deploys to CloudHub.

#### Required GitHub Secrets

Navigate to: **Repository Settings → Secrets and Variables → Actions**

**Required Secrets:**
- `ANYPOINT_USERNAME` - Your Anypoint Platform username
- `ANYPOINT_PASSWORD` - Your Anypoint Platform password  
- `BUSINESS_GROUP` - Your Anypoint organization/business group ID
- `SECURE_KEY` - Application encryption key (optional, defaults provided)

**Optional Variables:**
- `DEV_ENVIRONMENT` - Development environment name (default: "Sandbox")
- `PROD_ENVIRONMENT` - Production environment name (default: "Production")
- `MULE_VERSION` - Mule runtime version (default: "4.11.2")

#### Pipeline Workflow

1. **Build Stage**: Compile, test, and package the application
2. **Deploy Dev**: Deploy to development environment (Sandbox)
3. **Deploy Prod**: Deploy to production environment (after dev success)
4. **Notify**: Report deployment status

#### Triggering Deployments

- **Automatic**: Push to `main` or `master` branch
- **Manual**: Use "Run workflow" button in GitHub Actions tab
- **Pull Request**: Builds and tests only (no deployment)

### Method 2: Manual Maven Deployment

#### Development Environment
```bash
mvn clean deploy -DmuleDeploy -Pdev \
  -Danypoint.username="your-username" \
  -Danypoint.password="your-password" \
  -Danypoint.businessGroup="your-business-group"
```

#### Production Environment
```bash
mvn clean deploy -DmuleDeploy -Pprod \
  -Danypoint.username="your-username" \
  -Danypoint.password="your-password" \
  -Danypoint.businessGroup="your-business-group"
```

#### Using Environment Variables (More Secure)
```bash
export ANYPOINT_USERNAME="your-username"
export ANYPOINT_PASSWORD="your-password"
export ANYPOINT_BUSINESS_GROUP="your-business-group"

# Deploy to development
mvn clean deploy -DmuleDeploy -Pdev

# Deploy to production  
mvn clean deploy -DmuleDeploy -Pprod
```

### Method 3: Command Line Properties

#### Development Deployment
```bash
mvn clean deploy -DmuleDeploy \
  -Danypoint.username="your-username" \
  -Danypoint.password="your-password" \
  -Danypoint.environment="Sandbox" \
  -Danypoint.applicationName="hello-world-mule-dev" \
  -Danypoint.target="CloudHub-US-East-2" \
  -Danypoint.replicas="1" \
  -DworkerType="MICRO" \
  -Dworkers="1" \
  -Dregion="us-east-2" \
  -Danypoint.businessGroup="your-business-group"
```

#### Production Deployment
```bash
mvn clean deploy -DmuleDeploy \
  -Danypoint.username="your-username" \
  -Danypoint.password="your-password" \
  -Danypoint.environment="Production" \
  -Danypoint.applicationName="hello-world-mule-prod" \
  -Danypoint.target="CloudHub-US-East-2" \
  -Danypoint.replicas="2" \
  -DworkerType="SMALL" \
  -Dworkers="2" \
  -Dregion="us-east-2" \
  -Danypoint.businessGroup="your-business-group"
```

## Environment Configuration

### Development (Sandbox)
- **Application Name**: `hello-world-mule-dev`
- **Environment**: `Sandbox`
- **Worker Type**: `MICRO`
- **Workers**: `1`
- **Replicas**: `1`
- **Log Level**: `DEBUG`

### Staging (Design)
- **Application Name**: `hello-world-mule-staging`
- **Environment**: `Design`
- **Worker Type**: `SMALL`
- **Workers**: `1`
- **Replicas**: `1`
- **Log Level**: `INFO`

### Production
- **Application Name**: `hello-world-mule-prod`
- **Environment**: `Production`
- **Worker Type**: `SMALL`
- **Workers**: `2`
- **Replicas**: `2`
- **Log Level**: `WARN`

## CloudHub Configuration Parameters

### Worker Types and Pricing
- **MICRO**: 0.1 vCores, 500 MB RAM
- **SMALL**: 0.2 vCores, 1 GB RAM
- **MEDIUM**: 1 vCore, 1.5 GB RAM
- **LARGE**: 2 vCores, 3.5 GB RAM
- **XLARGE**: 4 vCores, 7.5 GB RAM
- **XXLARGE**: 8 vCores, 15 GB RAM

### Available Regions
- **US East**: `us-east-1`, `us-east-2`
- **US West**: `us-west-1`, `us-west-2`  
- **Europe**: `eu-west-1`, `eu-central-1`
- **Asia Pacific**: `ap-southeast-1`, `ap-southeast-2`

### CloudHub Targets
- **US East 1**: `CloudHub-US-East-1`
- **US East 2**: `CloudHub-US-East-2`
- **US West 1**: `CloudHub-US-West-1`
- **US West 2**: `CloudHub-US-West-2`
- **EU West 1**: `CloudHub-EU-West-1`
- **EU Central 1**: `CloudHub-EU-Central-1`

## Monitoring and Troubleshooting

### Deployment Monitoring
1. **GitHub Actions**: Monitor pipeline status in Actions tab
2. **Anypoint Runtime Manager**: View application status and logs
3. **CloudHub Console**: Access real-time application metrics

### Common Issues and Solutions

| Issue | Cause | Solution |
|-------|-------|----------|
| Authentication Failed | Invalid credentials | Verify ANYPOINT_USERNAME and ANYPOINT_PASSWORD |
| Application Name Exists | Duplicate app name | Use unique application names per environment |
| Insufficient Permissions | User lacks deployment rights | Contact admin for CloudHub deployment permissions |
| Environment Not Found | Invalid environment name | Verify environment exists in your organization |
| Deployment Timeout | Large application/slow network | Increase deploymentTimeout in pom.xml |

### Log Access
1. **Runtime Manager**: Go to Applications → Select App → Logs
2. **Command Line**: Use Anypoint CLI
   ```bash
   anypoint-cli runtime-mgr tail-logs <application-name>
   ```

## Security Best Practices

1. **Never commit credentials** to version control
2. **Use environment variables** for sensitive data
3. **Rotate passwords** regularly
4. **Use least privilege** principle for service accounts
5. **Enable encryption** for sensitive properties
6. **Monitor access logs** regularly

## Application Properties

The following properties are configured for runtime:

### HTTP Configuration
- `http.port`: `8081`
- `https.port`: `8082`
- `http.host`: `0.0.0.0`

### Security
- `secure.key`: Encryption key for sensitive data
- `encryption.algorithm`: `AES`

### Monitoring
- `anypoint.platform.config.analytics.agent.enabled`: `true`
- `log.level`: Environment-specific (DEBUG/INFO/WARN)

## Advanced Configuration

### Custom Properties
Add custom properties in the `<properties>` section of CloudHub deployment:

```xml
<properties>
    <custom.property1>value1</custom.property1>
    <custom.property2>value2</custom.property2>
</properties>
```

### VPC Configuration (Enterprise)
For VPC deployments, add:
```bash
-Dvpc.id="vpc-12345" \
-Dvpc.subnet="subnet-67890"
```

### SSL Certificate (Custom Domain)
For custom domains with SSL:
```bash
-Dssl.certificate.path="path/to/certificate" \
-Dssl.private.key.path="path/to/private/key"
```

## Support and Documentation

- **MuleSoft Documentation**: https://docs.mulesoft.com/
- **CloudHub Documentation**: https://docs.mulesoft.com/runtime-manager/cloudhub
- **Maven Plugin Documentation**: https://docs.mulesoft.com/mule-runtime/4.4/mmp-concept
- **GitHub Actions Documentation**: https://docs.github.com/en/actions

## Quick Reference Commands

```bash
# Test build
mvn clean compile

# Run tests
mvn clean test

# Package application
mvn clean package

# Deploy to development
mvn clean deploy -DmuleDeploy -Pdev

# Deploy to production
mvn clean deploy -DmuleDeploy -Pprod

# Check deployment status
mvn clean validate -DmuleDeploy -DskipDeploymentVerification=true