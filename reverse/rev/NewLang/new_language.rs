use std::io;
use std::io::Write;

fn main () -> io::Result<()>{
    println!("Basic Crackme");

    let mut user_input = String::new();
    let stdin = io::stdin();

    print!("password: ");
    io::stdout().flush().unwrap();
    stdin.read_line(&mut user_input)?;
    user_input = user_input.trim().to_string();

    let a = [34, 70, 22, 42, 10, 66, 14, 25, 17, 25, 12, 25, 25, 69, 26, 70, 64, 47, 17, 61, 57, 32, 58, 45, 12, 51, 53];

    let user_input_as_bytes: Vec<u8> = user_input.as_bytes().to_vec();

    let ciphered_input: Vec<u8> = user_input_as_bytes.iter()
                                                    .enumerate()
                                                    .map(|(i,&x)| {
                                                        if i%2 == 0 {
                                                            x ^ 102
                                                        }else{
                                                            x ^ 77
                                                        }
                                                    })
                                                    .rev()
                                                    .collect::<Vec<u8>>()
                                                    .iter()
                                                    .map(|&y| y +7)
                                                    .collect();

    let matching = ciphered_input.iter().zip(&a).filter(|&(a, b)| a == b).count();

    if matching == a.len() {
        println!("Bravo ! Tu peux valider avec ce flag");
    }else{
        println!("Désolé, il faut retourner lire du code source :/");
    }

    Ok(())
}