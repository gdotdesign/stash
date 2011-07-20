# Stash
## What is this?
First things first: **This is not a script (asset) loader.**

Stash initializes JavaScript objects, functions, etc… defined by requirements. It is like a script loader in the sense that you can set up requirements and stuff.

### Why?

#### Complex apps
If an app gets big and complex, it is usually gets broken down into parts, and those parts into seperate files. Then there is the problem of managing those files. There are projects for that like RequireJS or Packager (what MooTools uses), but they are complicated and they only check for files to be loaded not for the actual objects. With Stash you can just concate all your files and the parts/modules/classes etc… load as they supposed to.

#### Checking for loaded libraries
With Stash you can check for libraries and alike to be present and loaded.

## Example

    // Create a new Stash instance
    context = {}
    var stash = new Stash(context);
    // Define variable UnitA to the value 0 (via a function) after UnitB and UnitC are initialized
    stash.define(['UnitB','UnitC'], 'UnitA', function(){
      console.log(this.UnitB, this.UnitC)
      // 1 2
      return 0
    });
    stash.define(null,'UnitB',1);
    stash.define(null,'UnitC',2);
    
## Usage

new **Stash**(*context*,*prefix* = "",*verbose* = false)

   * context(object || function): Javascript object for the variables.
   * prefix(string): If added the variables will be initialized in a child object.
   * verbose(boolean): Wether or not to print the progress (for debugging)
   
stash.**define**(*requirements*,*name*,*value*)

   * requirements: Name or path of the javascript object that needs to be present in order to be initialized ("Array","Class.Mutators.Binds").
   * name: The variable name or path. If it's a name it will add it as a property to the current context, if it's a path it will create the neccessery objects.
   * value: Any valid javascript value (String, Object, Array), or a function. If it is a function it will run that function on the current context whitout any arguments.
   
## Referencing global objects
You can add global objects to the requirements list, just prefix it with an exlamation point "!".

    stash.define("!Array",'Unit',0)
    
The global scope is the **window** if used in browser or the current **exports** if used in node.js

## Referencing a local variable while using a Prefix
Just add a **@** prefix to the variable name

    stash.define("@var", 'Unit', 0)
    
## Tests
Node.js test requires **nodeunit**.

    nodeunit Specs/basic.coffee
