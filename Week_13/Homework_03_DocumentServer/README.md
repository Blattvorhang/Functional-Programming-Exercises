# Document Server
In this assignment, you are going to simulate a document server. The server is started on a separate thread and is reached through a corresponding channel. The server has to manage user accounts (name and password) and documents. Each document has a unique id, an owner and a list of viewers (users allowed to view the document in addition to the document’s owner). Operations require the user to authenticate, if the user account does not exist or the password is incorrect, an `Invalid_operation` exception is thrown. All errors described below should be be handled by not changing any state on the server and throwing an `Invalid_operation` exception to the caller of the respective method.

Implement:

1. **t**  
    A type t representing the channel to the server. Choose a type for the channel that fits your implementation’s needs. You may define additional types.
2. **document_server**  
    Function `document_server : unit -> t` that starts the server thread.

Then implement these functions where the first two arguments are the username and password used for authentication:

3. **add_account**  
    `add_account : string -> string -> t -> unit` that creates a new account with given username and password. No user with that name may exist already.
4. **publish**  
    `publish : string -> string -> string -> t -> int` where the arguments are username, password, document, server and the function returns the document’s unique id. Remember to throw an `Invalid_operation` exception if the authentication is incorrect.
5. **view**  
    `view : string -> string -> int -> t -> string` returns the document with the given id if it exists and the user is allowed to view the document.
6. **add_viewer**  
    `add_viewer : string -> string -> int -> string -> t -> unit` adds a user (4th argument) to the list of users allowed to view the given document (3rd argument). The document and user must exists. Furthermore, only the document’s owner may add viewers.
7. **change_owner**  
    `change_owner : string -> string -> int -> string -> t -> unit` changes the owner of the given document (3rd argument) to another user (4th argument). Again, the exception `Invalid_operation` is thrown if the user or document does not exists or the method is not called by the owner.

*Note: The tests are not independent and will fail if prior methods are not implemented; furthermore some aspects of some methods can only be tested once later methods have been implemented.*  
*Note: Pick some suitable message for the `Invalid_operation` exceptions you throw.*  
*Note: The tests work by executing lists of operations on a document server. The document ids in the test inputs refer to the id of the nth document added to the server and is not the actual id passed to methods.*
