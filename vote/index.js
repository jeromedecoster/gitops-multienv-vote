const nunjucks = require('nunjucks')
const express = require('express')
const axios = require('axios')

console.log('env.NODE_ENV:', process.env.NODE_ENV)
console.log('env.VERSION:', process.env.VERSION)
console.log('env.WEBSITE_PORT:', process.env.WEBSITE_PORT)

const NODE_ENV = process.env.NODE_ENV || 'production'
const VERSION = process.env.VERSION || 'v1.0.0'
const WEBSITE_PORT = process.env.WEBSITE_PORT || 3000

const app = express()

app.use(express.static('public'))
app.use(express.json())

nunjucks.configure('views', {
    express: app,
    autoescape: false,
    noCache: true
})

app.set('view engine', 'njk')

app.locals.node_env = NODE_ENV
app.locals.version = VERSION

if (NODE_ENV == 'development') {
    const livereload = require('connect-livereload')
    app.use(livereload())
}

// https://stackoverflow.com/a/1527820 
function randInt(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min
}

app.get('/', async (req, res) => {
    try {
        res.render('index')
        
    } catch (err) {
        return res.json({
            code: err.code, 
            message: err.message
        })
    }
})

/*
    curl http://localhost:3000/vote
*/
app.get('/vote', async (req, res) => {
    let up = randInt(1, 9)
    let down = randInt(1, 9)
    return res.send({ up, down })
})

/*
    curl http://localhost:3000/vote \
        --header 'Content-Type: application/json' \
        --data '{"vote":"up"}'
*/
app.post('/vote', async (req, res) => {
    try {
        console.log('POST /vote: %j', req.body)
        return res.send({ success: true, result: 'hello' })
        
    } catch (err) {
        console.log('ERROR: POST /vote: %s', err.message || err.response || err);
        res.status(500).send({ success: false, reason: 'internal error' });
    }
})

app.listen(WEBSITE_PORT, () => {
    console.log(`listening on port ${WEBSITE_PORT}`)
})
