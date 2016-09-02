# check-dell-warranty

check-dell-warranty is a small Ruby script that checks any number of Dell service tags for their warranty expiration dates. It requires at least one service tag to be passed as a parameter. Multiple service tags must be separate by space.

### Usage
```$ ./check-dell-warranty.rb <service tag 1> [service tag N] ...```

### Configuration
Prior to running, make sure @apikey is set to a valid Dell API key. You can get one by registering an account on Dell's website.

### Todo
- Display hardware model when using a switch

License
---
MIT
