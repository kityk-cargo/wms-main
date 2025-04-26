# Why and What is Common Error Format

## Purpose

The common error(s) format is needed:

1. To provide a glimpse on what the error(s) is and how WMS is supposed to handle it
2. To provide the common place where recovery advice could be looked at
3. To simplify generic error handling
4. To provide extendable, but not chaotic framework to describe problems in the system

## Comparison with Existing Standards

### RFC 9457

Why not use [RFC 9457](https://www.rfc-editor.org/rfc/rfc9457.html)?

RFC 9457 is crap and doesn't solve any of the problems highlighted before.

However it's a good idea to make it partially compatible (optional title/required detail in the root obj I guess).

I am most annoyed by the 'error'/'errors' switch which makes simple handling impossible. So this portion would be cut out in favor of ALWAYS have the root error that would be reported. It is a responsibility of the SERVER to keep the error relevant. It is a responsibility of the CLIENT to always have AT LEAST code to display the root error. It is OKAY not to have logic for multiple errors on any side if you don't need it.

## Challenges and Solutions

### 1. Error(s) Handling

**Challenge:**
- In some cases we need to handle one error that stops the execution of some process
- In some -- we need to handle multiple errors, and every of those is stopping the execution
- In some others we need to handle multiple errors that don't stop the execution

**Solution:**
Have one main error and OPTIONALLY more. 

The main is a guaranteed showstopper in sync protocols. In async, the criticality should be looked at. 

The 'more' otherErrors format MIGHT be reused alongside the partially correct/completed response if the 'partial success' event happens, but "error" means "stop the world". If there's more stop-the-world errors in the otherErrors section, the handling is open to the error creator but I recommend to highlight that the root error is "many things happened" and recovery suggestion "look into the otherErrors structure"

### 2. Complexity

**Challenge:**
The more things we include, the less easy it's to just fire an error with a message "shit happened". This has both advantages and disadvantages.

**Advantages:**
- Makes you feckin think about the error handling instead of just firing "oh shit" message and error 500
- Puts yourself and the user into the mindset of reflecting on recoverability and ways to recover rather than just firing the error and forgetting about it

**Disadvantages:**
- Sometimes you can't really handle it, or you don't even know WTF can be wrong (like catch Exception clauses) and you just need to wrap whatever
- Recoverability isn't a common thing. Sometimes you just can't. Or won't. Or there's too much to explain.
- Multiple errors might be taxing on otherwise simple proceedings.

**Solutions:**
1. Provide a fast way to fire 'oh shit it's 500' type error (my advice is to deprecate it to limit its usage)
   - That includes making recoveryAdvice optional and common agreement that when it's null it's 100% non-recoverable.
2. otherErrors is optional and used only when it's needed (e.g. multiple simple validations failed)

### 3. Non-viability of Library

**Challenge:**
Format is common but we can't guarantee common logic even within our services.

**Solution:**
Don't enforce common logic. Make the structure enough. Give people that use it more freedom dammit.

### 4. Automation

**Challenge:**
How TF we could automatically check that the errors fired from our services are conformant?

**Potential solutions:**
1. Pact file auto checker
2. Pretty much boils down to, since we have contracts, having a program that compares each file used against the error format in the negative scenarios.