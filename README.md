# check-dell-warranty

check-dell-warranty is a small Ruby script that checks any number of Dell service tags for their warranty expiration dates. It requires at least one service tag to be passed as a parameter. Multiple service tags must be separate by space.

### Usage
```$ ./check-dell-warranty.rb <service tag 1> [service tag N] ...```

### Configuration
Prior to running, make sure @apikey is set to a valid Dell API key. You can get one by registering an account on Dell's website.

### Known Problems
Sometimes Dell's API site times out in returning a response, which can cause the script to bail out. Just re-run it again if this happens.

### Todo
- Display hardware model when using a switch
- Display the INITIAL end date if no EXTENDED warranty is present

License
---
MIT
