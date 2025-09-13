# 7. SSM Automation Document
# -------------------------------
resource "aws_ssm_document" "install_software" {
  name          = "sequential-software-install"
  document_type = "Automation"

  content = jsonencode({
    schemaVersion = "0.3"
    description   = "Sequential install across SetC -> SetA -> SetB"
    # assumeRole    = "arn:aws:iam::607838039722:role/automation_ssm"
    parameters = {
      AutomationAssumeRole = {
        type        = "String"
        description = "(Optional) Role ARN for automation execution"
      }
    }
    mainSteps = [
      {
        name   = "InstallOnSetA"
        action = "aws:runCommand"
        inputs = {
          DocumentName = "AWS-RunShellScript"
          Targets = [{ Key = "tag:Role", Values = ["SetA"] }]
          Parameters = {
            commands = [
                "curl -s -o /tmp/install_setC.sh https://raw.githubusercontent.com/AmanSingh881/dummy/refs/heads/main/first_master.sh",
                "chmod +x /tmp/install_setC.sh",
                 "sudo /tmp/install_setC.sh"
            ]
          }
        }
      },
      {
        name   = "InstallOnSetB"
        action = "aws:runCommand"
        inputs = {
          DocumentName = "AWS-RunShellScript"
          Targets = [{ Key = "tag:Role", Values = ["SetB"] }]
          Parameters = {
            commands = [
              
              "curl -s -o /tmp/install_setC.sh https://raw.githubusercontent.com/AmanSingh881/dummy/refs/heads/main/masters.sh",
                "chmod +x /tmp/install_setC.sh",
                 "sudo /tmp/install_setC.sh"
            ]
          }
        }
        onFailure = "Abort"
      },
      {
        name   = "InstallOnSetC"
        action = "aws:runCommand"
        inputs = {
          DocumentName = "AWS-RunShellScript"
          Targets = [{ Key = "tag:Role", Values = ["SetC"] }]
          Parameters = {
            commands = [
              "curl -s -o /tmp/install_setC.sh https://raw.githubusercontent.com/AmanSingh881/dummy/refs/heads/main/worker.sh",
                "chmod +x /tmp/install_setC.sh",
                 "sudo /tmp/install_setC.sh"
            ]
          }
        }
        onFailure = "Abort"
      }
      
    ]
  })
  tags = local.common_tags
}

#######################

resource "null_resource" "trigger_ssm" {
  provisioner "local-exec" {
    command = <<EOT
      aws ssm start-automation-execution \
        --document-name ${aws_ssm_document.install_software.name} \
        --parameters AutomationAssumeRole=arn:aws:iam::607838039722:role/automation_ssm
    EOT
  }

  depends_on = [module.loadbalancer]
}


