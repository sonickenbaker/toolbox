const axios = require('axios');
const fs = require('fs');
const yaml = require('js-yaml');
const exec = require("child_process");

const read_targets_file = () => {
    try {
        let fileContents = fs.readFileSync('./targets.yaml', 'utf8');
        let data = yaml.load(fileContents);
        return data;
    } catch (e) {
        console.log(e);
    }
    return null
}

const process_response = (host, redirectTo, response) => {
    if (redirectTo) {
        let location = response.headers['location']
        if (location == 'https://' + redirectTo + '/') {
            console.log(`"${host}" have been redirect to "${location}"`)
        } else {
            console.error('ERROR')
        }
    } else {
        if (response.headers['location']) {
            console.error('A redirect has been performed when should not')
        } else {
            console.log(`No redirect for "${host}"`)
        }
    }
}

const make_request = async(host, path, redirectTo) => {
    let response = null
    try {
        response = await axios({
            url: 'http://localhost:8000' + path,
            method: 'get',
            headers: {'Host': host},
            maxRedirects: 0
        })
        process_response(host, redirectTo, response)
    }
    catch (err) {
        process_response(host, redirectTo, err.response)
    }
}

let targets = read_targets_file()['targets']
function perform_test(targets) {
    for(const element of targets) {
        let path = element.path ? element.path : '/';
        let redirectTo = element.redirect_to ? element.redirect_to : false
        make_request(element.host, path, redirectTo)
    }
}

const execute_command = (command) => {
    console.log(`Executing: "${command}"`)
    try {
        let stdout = exec.execSync(command);
        //console.log(stdout.toString())
    }
    catch(err) {
        console.error(err.stderr)
    }
}

const commands = ["docker ps -qa | xargs -r docker rm -fv", "docker rmi lua-filter_proxy", "docker-compose -f ./docker-compose.yaml up -d"]
commands.forEach( (command) => {
    execute_command(command)
})

perform_test(targets)