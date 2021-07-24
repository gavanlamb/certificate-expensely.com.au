data "aws_route53_zone" "zone" {
  name = "${var.domain_name}."
}

data "aws_lb" "expensely" {
  name = var.expensely_loadbalancer_name
}
data "aws_lb_listener" "expensely" {
  load_balancer_arn = data.aws_lb.expensely.arn
  port = 443
}
