# resource "aws_route53_zone" "yuushamaru" {
#   name = "yuushamaru.com"
# }

# resource "aws_route53_record" "A" {
#   zone_id = "Z0228891278J8X6SGEXKY"
#   name    = "yuushamaru.com"
#   type    = "A"
#   alias {
#     evaluate_target_health = true
#     zone_id                = "Z14GRHDCWA56QT"
#     name                   = "dualstack.alb-51442577.ap-northeast-1.elb.amazonaws.com"
#   }
# }
# resource "aws_route53_record" "NS" {
#   zone_id = "Z0228891278J8X6SGEXKY"
#   name    = "yuushamaru.com"
#   type    = "NS"
#   records = [
#     "ns-1079.awsdns-06.org.",
#     "ns-135.awsdns-16.com.",
#     "ns-1538.awsdns-00.co.uk.",
#     "ns-879.awsdns-45.net."
#   ]
#   ttl = 172800
# }

# resource "aws_route53_record" "SOA" {
#   zone_id = "Z0228891278J8X6SGEXKY"
#   name    = "yuushamaru.com"
#   records = [
#   "ns-1538.awsdns-00.co.uk. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400"
#   ]
#   ttl = 900
#   type    = "SOA"
# }

# resource "aws_route53_record" "CNAME" {
#   zone_id = "Z0228891278J8X6SGEXKY"
#   #   multivalue_answer_routing_policy = false
#   name    = "_3b8c900d1a11272c424ff16c123b35a8.yuushamaru.com"
#   records = ["_7f539c32bd185696cac51dfec4e52dea.mhbtsbpdnt.acm-validations.aws."]
#   type    = "CNAME"
#   ttl     = 300
# }