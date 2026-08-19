# What is in the standard library documentation?

First of all, The Rust Standard Library is divided into a number of focused modules, all listed further down this page. These modules are the bedrock upon which all of Rust is forged, and they have mighty names like `std::slice` and `std::cmp`. Modules' documentation typically includes an overview of the module along with examples, and are a smart place to start familiarizing yourself with the library.

Second, implicit methods on primitive types are documented here. This can be a source of confusion for two reasons:

1. While primitives are implemented by the compiler, the standard library implements methods directly on the primitive types (and it is the only library that does so), which are documented in the section on primitives.
2. The standard library exports many modules *with the same name as primitive types*. These define additional items related to the primitive type, but not the all-important methods.

So for example there is a page for the primitive type `char` that lists all the methods that can be called on characters (very useful), and there is a page for the module `std::char` that documents iterator and error types created by these methods (rarely useful).

Note the documentation for the primitives `str` and `[T]` (also called 'slice'). Many method calls on `String` and `Vec<T>` are actually calls to methods on `str` and `[T]` respectively, via deref coercions.

Third, the standard library defines The Rust Prelude, a small collection of items - mostly traits - that are imported into every module of every crate. The traits in the prelude are pervasive, making the prelude documentation a good entry point to learning about the library.

And finally, the standard library exports a number of standard macros, and lists them on this page (technically, not all of the standard macros are defined by the standard library - some are defined by the compiler - but they are documented here the same). Like the prelude, the standard macros are imported by default into all crates.
