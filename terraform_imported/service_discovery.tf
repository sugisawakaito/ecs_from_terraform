resource "aws_service_discovery_private_dns_namespace" "namespace" {
  name = "ecs.internal"
  vpc  = aws_vpc.vpc.id
}

resource "aws_service_discovery_private_dns_namespace" "cluster" {
  name = "cluster"
  vpc  = aws_vpc.vpc.id

  tags = {
    AmazonECSManaged = "true"
  }
}

resource "aws_service_discovery_service" "webapp" {
  name         = "webapp"
  namespace_id = aws_service_discovery_private_dns_namespace.namespace.id

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.namespace.id

    dns_records {
      type = "A"
      ttl  = 60
    }
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

resource "aws_service_discovery_service" "rest-api" {
  name         = "rest-api"
  namespace_id = aws_service_discovery_private_dns_namespace.namespace.id

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.namespace.id

    dns_records {
      type = "A"
      ttl  = 60
    }
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}