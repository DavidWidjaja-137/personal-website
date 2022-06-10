<script setup>
import NameCard from './components/NameCard.vue'
import IntroStatement from './components/IntroStatement.vue'
import BlogList from './components/BlogList.vue'
import FooterCard from './components/Footer.vue'

const techBlogItems = ["Blog 1", "Blog 2", "Blog 3"]

const personalBlogItems = ["Blog 1", "Blog 2", "Blog 3"]

const reBlogItems = ["Blog 1", "Blog 2", "Blog 3"]

</script>

<template>
  <header>
    <NameCard />
  </header>

  <main>

    <IntroStatement />

    <div class="blog-section">
      <div class="blog">
        <BlogList blogTitle="Tech Blog" :blogItems="techBlogItems"/>
      </div>
      <div class="blog">
        <BlogList blogTitle="Personal Blog" :blogItems="personalBlogItems"/>
      </div>
      <div class="blog">
        <BlogList blogTitle="RE Blog" :blogItems="reBlogItems"/>
      </div>
    </div>

    <footer>
      <FooterCard />
    </footer>

  </main>

</template>

<style>

  @import './assets/base.css';

  .blog-section {
    display: flex;
    width: 50vw;
    margin-left:auto;
    margin-right:auto;
  }

  .blog-section > div {
    flex: 1;
  }

  footer {
    text-align: center;
    justify-content: center;
    padding: 0.5vw;
    background-color: #45a1ff;
    color: #fff;
  }

</style>
