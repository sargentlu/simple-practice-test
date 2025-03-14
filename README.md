# simple-practice-test
SimplePractice Technical Assessment

## Overview

The **simple-practice-test** repo contains tests for client creation at https://secure.simplepractice.com/.
The three test cases cover the following secenarios:

1. *Returns an error if trying to log in with incorrect credentials*:
    - Tries logging into SimplePractice with incorrect credentials, verifies that the login attempt
      fails and that a warning dialog pops up with the following message:
        ```
            Enter the email associated with your account and double-check
            your password. If you're still having trouble, you can reset
            your password.
        ```
2. *Creates a client with the minimum required info*:
   - Creates a client with only their first and last names
3. *Creates a client with more info*:
   - Creates a client with their first and last names, as well as
     entering their birth date, office, email, and phone number.

A test run should look something similar to this:

```
Creating simple-practice-test_simple-practice-test_run ... done

Simple Practice Test
  Returns an error if trying to log in with incorrect credentials
  Creates a client with the minimum required info
  Creates a client with more info

Finished in 43.84 seconds (files took 0.27028 seconds to load)
3 examples, 0 failures

Stopping chrome ... done
Removing chrome ... done
Removing network simple-practice-test_default
Untagged: sergiomtzlu/simple-practice-test:latest
Deleted:
```

## Setup

The tests can be run in two ways.

### 1. Via the `simple-practice-run-test` repo

**Note**: This method only runs test 3 (*Creates a client with more info*)
successfully once, as the client's email and password are stored as secrets
and these cannot be used more than once.
 
1. Clone `simple-practice-run-test` and go to its root directory
    ```
    git clone git@github.com:sargentlu/simple-practice-run-test.git
    cd simple-practice-run-test/
    ```
2. Run the `run_tests.sh` script
    ```
    # Run this script with the 'clean' argument to 
    # remove the test image after running the tests
    ./run_tests.sh clean
    ```

### 2. Cloning the repo, setting it up, and running the tests locally

1. Clone this repo and go to its root directory
    ```
    git clone git@github.com:sargentlu/simple-practice-test.git
    cd simple-practice-test/
    ```
2. Install the project required gems
    ```
    bundle install
    ```
3. Now that the 'sekrets' gem is installed, update `settings.yml.enc`.
   A mock, unusable `.sekrets.key.example` is included in the repo, but
   it should be replaced with `.sekrets.key` before building the project.
   This is especially useful for updating `CLIENT_EMAIL` and `CLIENT_PHONE`,
   which need to be updated so that *Creates a client with more info*
   succeeds.
    ```
    sekrets edit settings.yml.enc
   
    # Within the sekrets session, edit the values 
    INCORRECT_EMAIL=<>
    INCORRECT_PWD=<>
    USER_EMAIL=<>
    USER_PWD=<>
    CLIENT_EMAIL=<>
    CLIENT_PHONE=xxxxxxxxxx #Must have 10 digits
    ```
4. Run the tests. This can be done in one of two ways:
    1. Run the `run_tests.sh` script. This will spin up
       two containers: one running this test, and a second
       one with a Chromium browser to run the tests on.
    ```
    # Run this script with the 'clean' argument to 
    # remove the test image after running the tests.
    # Run it this way if you want to 
    scripts/run_tests.sh clean
   
    # Or run it without arguments so the test can be run again
    without needing to restart the browser
    scripts/run_tests.sh
    ```
