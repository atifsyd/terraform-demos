### acceptor route table
data "aws_route_table" "acceptor_rtb" {
  provider = aws.dst
  vpc_id   = var.acceptor_vpc_id
  subnet_id = var.acceptor_intra_subnet_id
}

# Requestor side VPC peering connection
resource "aws_vpc_peering_connection" "requestor_connection" {
  provider = aws.src
  vpc_id      = var.requestor_vpc_id
  peer_vpc_id = var.acceptor_vpc_id
  peer_region = var.acceptor_region
  auto_accept = false
  tags = {
    Side = "Requestor"
  }
}

# Acceptors side connection request
resource "aws_vpc_peering_connection_accepter" "acceptor_connection" {
  provider                  = aws.dst
  vpc_peering_connection_id = aws_vpc_peering_connection.requestor_connection.id
  auto_accept               = true
  tags = {
    Side = "Acceptor"
  }
}

### Requestor route
resource "aws_route" "requestor_route" {
  provider = aws.src
  route_table_id            = var.requestor_route_table_id
  destination_cidr_block    = var.acceptor_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.requestor_connection.id
  depends_on = [
    aws_vpc_peering_connection.requestor_connection
  ]
}

### Acceptor route
resource "aws_route" "acceptor_route" {
  provider                  = aws.dst
  route_table_id            = data.aws_route_table.acceptor_rtb.route_table_id
  destination_cidr_block    = var.requestor_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.requestor_connection.id
  depends_on = [
    aws_vpc_peering_connection.requestor_connection
  ]
}