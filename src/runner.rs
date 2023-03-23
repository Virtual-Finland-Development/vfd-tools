use super::cli::CliArguments;
use anyhow::Result;

pub struct Runner {
    args: CliArguments,
}

impl Runner {
    pub fn new(args: CliArguments) -> Self {
        Runner { args }
    }

    pub fn run(&self) -> Result<()> {
        if self.args.test {
            println!("test");
        }
        if self.args.fest {
            println!("fest");
        }
        Ok(())
    }
}
