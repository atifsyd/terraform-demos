#EKS cluster
cluster_name            = "cluster-1"
iac_environment_tag     = "development"
name_prefix             = "cluster"
main_network_block      = "10.0.0.0/16"
subnet_prefix_extension = 4
zone_offset             = 8

# Network
admin_users                              = ["syedati", "admin"]
developer_users                          = ["jon", "doe"]
asg_instance_types                       = ["t3.small", "t2.small"]
autoscaling_minimum_size_by_az           = 1
autoscaling_maximum_size_by_az           = 10
autoscaling_average_cpu                  = 30
spot_termination_handler_chart_name      = "aws-node-termination-handler"
spot_termination_handler_chart_repo      = "https://aws.github.io/eks-charts"
spot_termination_handler_chart_version   = "0.9.1"
spot_termination_handler_chart_namespace = "kube-system"
