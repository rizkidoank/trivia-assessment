const request = require('request');

const BACKEND_URL = process.env.BACKEND_URL
const BACKEND_PORT = process.env.BACKEND_PORT

const express = require('express')
const app = express()
const port = 3000

app.get('/', function (req, res) {
    request(`${BACKEND_URL}:${BACKEND_PORT}`,{ json: true }, (err, body) => {
        if (err) {
            return console.error(err)
        }
        res.send(body.body.text)
    })
})

app.listen(port, () => console.log(`Example app listening at http://localhost:${port}`))
