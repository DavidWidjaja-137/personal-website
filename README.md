# Personal Website

Source code for David Pratama Widjaja's personal Website


## Making things hard for myself

I could have hosted this on GitHub Pages or just used a WordPress/Wix template, but that would have been too easy. 

Half the fun of making a personal website is to have a platform to introduce yourself. The other half of the fun comes
from building the website itself, from learning web development for real, writing your own simple web server, 
containerizing and provisioning hosting resources for the website. 

So this is what I did:
- Learnt Vue.js and React to build the frontend, but ended up using Vue because it is the more convenient and 'liked'
  framework.
- Learnt Golang to build the backend, because it is a popular language for that purpose.
- Learnt how to use Docker then containerized the entire application with it.
- Read the AWS Lightsail docs and then hosted the website on it.
- Purchased and set up a custom domain on AWS Route53.
- Learnt some stuff about public key cryptography and TLS, and authenticated my website with a digital certificate
  from Amazon Certificate Manager.
- Realised that AWS Lightsail/Heroku didn't teach me enough about web hosting because those are PAAS(Platform As A Service)
  and they basically handled everything for you. Used AWS ECS with AWS Fargate + AWS ECR 
  to host my website, after setting up a AWS VPC.
- Set up a CI/CD toolchain with GitHub Actions so that I don't have to push containers manually to AWS anymore.

This is of course, completely overkill for a personal website.
