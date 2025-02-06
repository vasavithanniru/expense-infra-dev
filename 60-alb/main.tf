#this is private lb, only vpn/bastion can access

module "ingress_alb" {
  source = "terraform-aws-modules/alb/aws"

  internal = false

  name    = "${local.resource_name}-ingress-alb" #expens-dev-ingress-alb
  vpc_id  = local.vpc_id
  subnets = local.public_subnet_ids
  create_security_group = false
  security_groups = [local.ingress_alb_sg_id]
  enable_deletion_protection = false
  tags = merge(
    var.common_tags,
    var.ingress_alb_tags
  )
}


resource "aws_lb_listener" "http" {
  load_balancer_arn = module.ingress_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>Hello, i am from application alb http</h1>"
      status_code  = "200"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = module.ingress_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = local.https_certificate_arn

  default_action {
    type             = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>Hello, I am from Web ALB HTTPS</h1>"
      status_code  = "200"
    }
  }
}

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"

  zone_name = var.zone_name

  records = [
    {
      name    = "expense-${var.environment}" #expense-dev.vasavi.online - if we hit this we will get response through bastion
      type    = "A"
      alias   = {
        name    = module.ingress_alb.dns_name
        zone_id = module.ingress_alb.zone_id   #this belongs to WLB internal hosted zone
      }
      allow_overwrite = true
    }
  ]
}

resource "aws_lb_target_group" "expense" {
  name     = local.resource_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = local.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    interval = 5
    matcher = "200-299"
    path = "/"
    port = 80
    protocol = "HTTP"
    timeout = 4
  }
}

resource "aws_lb_listener_rule" "frontend" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 100 # low priority will be evaluated first

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.expense.arn
  }

  condition {
    host_header {
      values = ["expense-${var.environment}.${var.zone_name}"] #expense-dev.vasavi.online
    }
  }
}
 
  