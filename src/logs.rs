pub fn log_heading(heading: impl Into<String>) {
    println!("----- {} ...", heading.into());
}
