A creator or a builder who owns a `Publisher` object created in their package can use the `sui::display` module to define display properties for their objects. To get a Publisher object check out the [[Setting up Publisher]] guide.

`Display<T>` is an object that specifies a template for the type `T` (for example, for a type `0x2::capy::Capy` the display would be `Display<0x2::capy::Capy>`). All objects of the type `T` will be processed in the Sui Full Node RPC througth the matching `Display` template.

