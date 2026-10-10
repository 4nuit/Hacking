#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct super_secure_struct {
    char nom[16];
    long balance;
    void *admin_func;
};

void menu(){
    puts("1 - Créer un utilisateur");
    puts("2 - Connexion");
}

void menu2(){
    puts("1 - Ajouter de l'argent");
    puts("2 - Payer un café (70 écus)");
    puts("3 - Espace administrateur");
}

int get_int(){
    int choix;
    printf("Choix ? ");
    scanf("%d",&choix);
    return choix;
}

void espace_admin(){
    char cmd[20];
    for(int i=0; i<2; i++){
        printf("Commande à executer :");
        gets(cmd);
        system(cmd);
    }
}

void main2(struct super_secure_struct *utilisateur){
    int choix;
    while(1==1){
    menu2();
    choix = get_int();
    int montant;

    switch(choix){
        case 1:
            printf("Combien d'écus voulez vous mettre sur le compte : ");
            scanf("%d",&montant);
            if (montant > 50){
                puts("Vous ne pouvez pas ajouter plus de 50 écus");
            }else{
                utilisateur->balance += montant;
            }
        break;
        case 2:
            *(long *) &(utilisateur->balance) -= 70;
        break;
        case 3:
        if(utilisateur->admin_func == NULL){
            puts("Cette fonction est vide !");
            exit(0);
        }else{
            ((void(*)())utilisateur->admin_func)();
            exit(0);
        }
        break;
        default:
        break;
    }
    }
}

int main(){
    int choix;
    struct super_secure_struct *utilisateur=NULL;
    char local_name[20];
    memset(local_name, 0, 20);
    
    setbuf(stdout, 0);
    setbuf(stdin, 0);

    while(1==1){
    menu();
    choix = get_int();

    switch (choix){
        case 1:
        if(utilisateur == NULL){
            utilisateur = (struct super_secure_struct*) malloc(sizeof(struct super_secure_struct));
            utilisateur->balance = 0;
            utilisateur->admin_func = NULL;
            printf("Nom du nouvel utilisateur: ");
            scanf("%s",utilisateur->nom);
        }else{
            puts("L'utilisateur existe déjà !");
        }
        break;
        case 2:
        if(utilisateur != NULL){
            printf("Entrez un nom: ");
            scanf("%s",local_name);
            if(strcmp(local_name, utilisateur->nom) == 0){
                main2(utilisateur);
            }
        }else{
            puts("");
        }
        break;
        default:
        puts("Choix non valide\n");
        break;
    }
    }
}