// @draft: https://github.com/clap-rs/clap/blob/master/clap_complete/examples/completion-derive.rs

use clap::Command;
use clap_complete::{generate, Generator};

use std::io;
use std::io::Error;

mod cli;
use cli::CliArguments;

fn print_completions<G: Generator>(gen: G, cmd: &mut Command) {
    generate(gen, cmd, cmd.get_name().to_string(), &mut io::stdout());
}

fn main() -> Result<(), Error> {
    let args = CliArguments::parse();

    if let Some(generator) = args.generator {
        let mut cmd = CliArguments::command();
        eprintln!("Generating completion file for {generator:?}...");
        print_completions(generator, &mut cmd);
    } else {
        println!("{args:#?}");
    }

    /*  let outdir = match env::var_os("OUT_DIR") {
        None => return Ok(()),
        Some(outdir) => outdir,
    };

    let mut cmd = build_cli();
    let path = generate_to(
        Bash,
        &mut cmd,    // We need to specify what generator to use
        "vfd-tools", // We need to specify the bin name manually
        outdir,      // We need to specify where to write to
    )?;

    println!("cargo:warning=completion file is generated: {:?}", path); */

    Ok(())
}
