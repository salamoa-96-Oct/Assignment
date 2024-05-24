output "js_vpc_id" {
  value = aws_vpc.main.id
}
output "js_public_subets_id" {
  value = aws_subnet.public.id
}
output "js_private_subets_id" {
  value = aws_subnet.private.id
}