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
}

data "aws_route53_zone" "zone" {
  name = var.domain
}

resource "aws_ses_domain_identity" "identity" {
  domain = var.domain
}

resource "aws_route53_record" "record" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "_amazonses.${local.instance_id}.${aws_ses_domain_identity.identity.id}."
  type    = "TXT"
  ttl     = "600"
  records = [aws_ses_domain_identity.identity.verification_token]
}

resource "aws_ses_domain_identity_verification" "verification" {
  domain = aws_ses_domain_identity.identity.id

  depends_on = [aws_route53_record.record]
}
