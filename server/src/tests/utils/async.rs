use futures_core::Future;
use tokio::{runtime::Handle, task};

pub(super) fn block_on<F: Future>(future: F) -> F::Output {
    task::block_in_place(|| Handle::current().block_on(future))
}
