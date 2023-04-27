# Copyright Amazon.com, Inc. or its affiliates. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#

data "jinja_template" "slackgpt-irsteam-email" {
  template = var.account_email_template
  context {
    data = jsonencode({
      account_name = "slackgpt-irsteam"
    })
    type = "json"
  }
}

module "slackgpt-irsteam" {
  source = "./modules/aft-account-request"

  control_tower_parameters = {
    AccountEmail = data.jinja_template.slackgpt-irsteam-email.result
    AccountName  = "slackgpt-irsteam"
    # Syntax for top-level OU
    ManagedOrganizationalUnit = "Deployments"
    # Syntax for nested OU
    SSOUserEmail     = data.jinja_template.slackgpt-irsteam-email.result
    SSOUserFirstName = "Paul"
    SSOUserLastName  = "Nickerson"
  }
  change_management_parameters = {
    change_requested_by = "Paul Nickerson"
    change_reason       = "Slackgpt IRS team deployment"
  }
  account_tags = {
    "environment" = "prod"
  }

  account_customizations_name = "slackgpt"
}
