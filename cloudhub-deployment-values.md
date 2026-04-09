# CloudHub Deployment Parameter Values

## Method 1: Maven Command Line Properties (Recommended for CI/CD)

```bash
mvn clean deploy -DmuleDeploy \
  -Danypoint.username=your-username \
  -Danypoint.password=your-password \
  -Danypoint.environment=Production \
  -Danypoint.applicationName=hello-world-mule-prod \
  -Danypoint.target=CloudHub-US-East-2 \
  -Danypoint.replicas=1\
  -DworkerType=MICRO \
  -Dworkers=1 \
  -Dregion=us-east-2
```

## Method 2: Add Properties to pom.xml (Good for defaults)

Add these properties to your `<properties>` section in pom.xml:

```xml
<properties>
    <!-- Existing properties -->
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
    <app.runtime>4.11.2</app.runtime>
    <mule.maven.plugin.version>4.2.0</mule.maven.plugin.version>
    
    <!-- CloudHub Deployment Properties -->
    <anypoint.username>${env.ANYPOINT_USERNAME}</anypoint.username>
    <anypoint.password>${env.ANYPOINT_PASSWORD}</anypoint.password>
    <anypoint.environment>Sandbox</anypoint.environment>
    <anypoint.applicationName>hello-world-mule</anypoint.applicationName>
    <anypoint.target>CloudHub-US-East-2</anypoint.target>
    <anypoint.{"email":"<EMAIL_ADDRESS_replicas>1</anypoint.0>"}replicaule.version>4.11.2</mule.version>
    <workerType>MICRO</workerType>
    <workers>1</workers>
    <region>us-east-2</region>
</properties>
```

## Method 3: Environment Variables (Secure for credentials)

Set environment variables:
```bash
export ANYPOINT_USERNAME=your-username
export ANYPOINT_PASSWORD=your-password
export ANYPOINT_ENVIRONMENT=Production
export ANYPOINT_APPLICATION_NAME=hello-world-mule-prod
export ANYPOINT_TARGET=CloudHub-US-East-2
export ANYPOINT_REPLICAS=2
```

Then deploy with:
```bash
mvn clean deploy -DmuleDeploy
```

## Method 4: Maven Profiles (Environment-specific)

Add profiles to your pom.xml:

```xml
<profiles>
    <profile>
        <id>dev</id>
        <properties>
            <anypoint.environment>Sandbox</anypoint.environment>
            <anypoint.applicationName>hello-world-mule-dev</anypoint.applicationName>
            <anypoint.replicas>1</anypoint.replicas>
            <workerType>MICRO</workerType>
            <workers>1</workers>
        </properties>
    </profile>
    <profile>
        <id>prod</id>
        <properties>
            <anypoint.environment>Production</anypoint.environment>
            <anypoint.applicationName>hello-world-mule-prod</anypoint.applicationName>
            <anypoint.replicas>2</anypoint.replicas>
            <workerType>SMALL</workerType>
            <workers>2</workers>
        </properties>
    </profile>
</profiles>
```

Deploy with profile:
```bash
mvn clean deploy -DmuleDeploy -Pdev
# or
mvn clean deploy -DmuleDeploy -Pprod
```

## Parameter Values Guide

### Required Values:
- **anypoint.username**: Your Anypoint Platform username
- **anypoint.password**: Your Anypoint Platform password
- **anypoint.environment**: `Sandbox`, `Design`, `Production`, etc.
- **anypoint.applicationName**: Unique name in CloudHub (e.g., `hello-world-mule-prod`)
- **anypoint.target**: `CloudHub-US-East-1`, `CloudHub-US-East-2`, `CloudHub-EU-West-1`, etc.
- **anypoint.replicas**: Number of instances (1, 2, 3, etc.)

### Optional Values:
- **workerType**: `MICRO`, `SMALL`, `MEDIUM`, `LARGE`, `XLARGE`, `XXLARGE`
- **workers**: Number of workers (for CloudHub 1.0)
- **region**: `us-east-1`, `us-east-2`, `eu-west-1`, etc.

## Security Best Practices:
1. **Never hardcode credentials** in pom.xml
2. Use **environment variables** for sensitive data
3. Use **Maven properties** for non-sensitive configuration
4. Use **profiles** for environment-specific settings