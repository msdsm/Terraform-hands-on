provider "aws" {
  region  = "us-west-2"
  profile = "msd_user"
}

resource "random_pet" "petname" {
  length    = 5
  separator = "-"
}

resource "aws_s3_bucket" "sample" {
  bucket = random_pet.petname.id

  tags = {
    public_bucket = false
  }
}
