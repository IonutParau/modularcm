# What is this markdown file for?

This markdown file is to tell you how you should do things when coding modules.

# Ok, what should I do?

1. Put the code for creating cells in the `init` queue. (you can use `Queue()` for that)

Example:

```lua
Queue("init", function()
  CreateCell("my_cell", {})
end)
```

2. Add all listeners when the module is loaded, not in the init queue.

This is because if you do it in the init queue, you might miss some important stuff.

3. Specify your dependencies.

Specify your dependencies. This is because if you don't, people might use your module without installing those dependencies and you will get 15,000 DMs of people telling you your code sucks and that you are a garbage programmer.

And yes, package managers CAN count as dependencies.
