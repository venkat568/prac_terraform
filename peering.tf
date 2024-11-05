resource "aws_vpc_peering_connection" "peer" {
    peer_owner_id = var.peer_owner_id
    peer_vpc_id = aws_vpc.prod.id
    vpc_id = aws_vpc.dev.id
    peer_region = "us-east-1"
    tags = {
      Name ="dev-prod"
    }
}


resource "aws_vpc_peering_connection_accepter" "accepter" {
    provider = aws.central
    vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
    auto_accept = true
    tags = {
      "Name" = "accepter"
    }
  
}