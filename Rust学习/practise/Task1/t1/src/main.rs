
mod L2;
fn main() {
    for ele in 'a'..='z' {
        println!("{}",ele);
    }

    for ele in 'A'..='Z' {
        println!("{}",ele);
    }

    L2::l2file::print_A_to_z();
}
