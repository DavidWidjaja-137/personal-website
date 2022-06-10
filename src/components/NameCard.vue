<script>
    export default {
        data() {
            return {
                fullName: "David Pratama Widjaja",
                emailAddress: "widjaja (dot) david (at) ymail (dot) com"
            }
        }
    }
</script>

<template>
    <h1>
        {{ fullName }}
    </h1>
    <h2>
        {{ emailAddress }}
    </h2>
    <div class="logo-wrapper">
        <div class="logo-element-1">
            <a href="https://github.com/DavidWidjaja-137">
                <img class="logo-img" alt="GitHub Logo linked to my github account" src="/src/assets/GitHub-Mark-120px-plus.png">
            </a>
        </div>
        <div class="logo-element-2">
            <a  href="https://www.linkedin.com/in/david-pw">
                <img class="logo-img" alt="LinkedIn Logo linked to my linkedin account" src="/src/assets/LI-In-Bug.png">
            </a>
        </div>
    </div>
    <h3>My CV can be downloaded <a href="/src/assets/CV.pdf" download="/src/assets/CV.pdf">here</a></h3>

</template>

<style>

</style>