resource "aws_ecr_repository" "ecr" {
  name         = "choonyee-ecr"
  force_delete = true
}

module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "~> 5.9.0"

  cluster_name = "choonyee-ecs"
  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 100
      }
    }
  }

  services = {
    choonyee-flask-ecs-taskdef2 = { #task definition and service name -> #Change
      cpu    = 512
      memory = 1024

      container_definitions = {
        y-flask-app = { #container name -> Change
          essential = true
          image     = "255945442255.dkr.ecr.ap-southeast-1.amazonaws.com/yap-ecr:066ecc17ba5a2fc36b13b8fa63e787937d1eed8c"
          port_mappings = [
            {
              containerPort = 8080
              protocol      = "tcp"
            }
          ]
        }
      }
      assign_public_ip                   = true
      deployment_minimum_healthy_percent = 100
      subnet_ids                   = data.aws_subnets.public.ids #["subnet-02ade1d135132baff", "subnet-01528a30e6cf8f25e", "subnet-05cb129a6131bf583"] #List of subnet IDs to use for your tasks
      security_group_ids           = [aws_security_group.ecs-sg.id] #[sg-046a9e90621fa82a9] #Create a SG resource and pass it here
    }
  }
}    
