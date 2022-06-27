const updateUI = async () => {
    const result = await axios.get('/vote')
    console.log('GET /vote:', result)
    document.querySelector('#up span').textContent = result.data.up
    document.querySelector('#down span').textContent = result.data.down
    document.querySelector('.box').classList.remove('hidden')
}

const submit = async (event) => {
    console.log('POST /vote:', { vote: event.target.id }, event.target)
    await axios.post('/vote', { vote: event.target.id })
    updateUI()
}

document.querySelector('#up').onclick = submit
document.querySelector('#down').onclick = submit

updateUI()