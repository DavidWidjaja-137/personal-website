<script>
    export default {
        props: ['blogTitle', 'blogItems'],
        data() {
            return {
                BlogTitle: this.blogTitle,
                items: this.blogItems
            }
        }
    }
</script>

<template>
    <h3>
        {{ BlogTitle }}
    </h3>
    <ul>
        <li v-for="item in items">{{ item }}</li>
    </ul>
</template>

<style>
</style>