# Copyright 2020 Pivotal Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http:#www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


locals {
  instance_id = "ses-${substr(sha256(var.instance_name), 0, 16)}"
  user_name = "${local.instance_id}-${var.user_name}"
}
resource "aws_iam_user" "user" {
    name = local.user_name
    path = "/cf/"
}

resource "aws_iam_access_key" "access_key" {
    user = aws_iam_user.user.name
}

resource "aws_iam_user_policy" "user_policy" {
    name   = format("%s-p", local.user_name)

    user   = aws_iam_user.user.name

    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action":[
        "ses:SendEmail",
        "ses:SendRawEmail"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}