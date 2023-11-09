class Profile {
  final String image;
  final String name;
  final String description;
  final String rate;
  final String ncomments;
  final String release;
  final String lastJobs;
  final String socialInstagram;
  final String socialYoutube;

  Profile({
    required this.name,
    this.image = "",
    this.description = "",
    this.rate = "",
    this.ncomments = "",
    this.release = "",
    this.lastJobs = "",
    this.socialInstagram = "",
    this.socialYoutube = "",
  });
}

class Gig {
  final String name;
  final String image;
  final String gigdescription;
  final String gigdetails;
  final String local;
  final String cidade;
  final String date;
  final String hour;
  final String cache;
  final String musicianCategory;
  final String joinedMusician;
  final String instrument;

  Gig({
    required this.name,
    required this.image,
    required this.gigdescription,
    required this.local,
    required this.cidade,
    required this.date,
    required this.hour,
    required this.cache,
    this.gigdetails = "",
    this.musicianCategory = "",
    this.joinedMusician = "",
    this.instrument = "",
  });
}

class Message {
  final String name;
  final String image;
  final String local;
  final String ultimamsg;

  Message(
      {required this.image,
      required this.name,
      required this.local,
      required this.ultimamsg});
}

final List<Message> msg = [
  Message(
      image: "assets/profiles/jr.png",
      name: "Junior Groovador",
      local: "Natal/RN",
      ultimamsg: "Vamos vencer na vida?"),
  Message(
      image: "assets/profiles/kiko.png",
      name: "Kiko Loureiro",
      local: "Natal/RN",
      ultimamsg: "Ta livre pra um free amanhã?")
];

final List<Profile> profiles = [
  Profile(
    image: "assets/profiles/kiko.png",
    name: "Kiko Loureiro",
    description: "Guitarrista, produtor, compositor",
    rate: "5.0",
    ncomments: "589",
    release:
        "Músico experiente com mais de 20 anos de carreira. Trabalhou com bandas de diversos gêneros e gravou inúmeros álbuns de sucesso. Reconhecido por suas habilidades excepcionais como guitarrista.",
    lastJobs:
        "Recentemente, Kiko colaborou com uma banda internacionalmente famosa na gravação de seu álbum mais recente, demonstrando sua versatilidade musical.",
  ),
  Profile(
    image: "assets/profiles/greg.png",
    name: "Greg Phillinganes",
    description: "Gravou apenas o Thriller",
    rate: "5.0",
    ncomments: "86M",
    release:
        "Tecladista de renome internacional com uma carreira repleta de sucessos. Seu talento é evidente em cada nota que toca, e ele é respeitado por músicos e fãs de todo o mundo.",
    lastJobs:
        "Nos últimos anos, Greg realizou uma turnê mundial, apresentando-se em estádios lotados e tocando músicas icônicas que cativaram multidões.",
  ),
  Profile(
    image: "assets/profiles/jr.png",
    name: "Junior Groovador",
    description: "Baixista, dançarino",
    rate: "5.0",
    ncomments: "76",
    release: "Talento musical com incrível habilidade no baixo.",
    lastJobs: "Realizou turnês em todo o mundo com várias bandas.",
  ),
  Profile(
    image: "assets/profiles/felipe.png",
    name: "Felipe Andreoli",
    description: "Baixista, produtor, compositor",
    rate: "5.0",
    ncomments: "259",
    release: "Baixista talentoso com composições originais.",
    lastJobs: "Produziu álbuns aclamados e colaborou com músicos famosos.",
  ),
  Profile(
    image: "assets/profiles/simon.png",
    name: "Simon Phillips",
    description: "Toquei só no Toto",
    rate: "5.0",
    ncomments: "2M",
    release: "Baterista lendário com uma carreira notável.",
    lastJobs: "Participou de gravações icônicas e turnês de sucesso.",
  ),
  Profile(
    image: "assets/profiles/steve.png",
    name: "Steve Lukather",
    description: "Eu sou o Toto e gravei o Thriller",
    rate: "5.0",
    ncomments: "89M",
    release: "Guitarrista influente e membro da banda Toto.",
    lastJobs: "Participou de gravações icônicas e shows memoráveis.",
  ),
  Profile(
    image: "assets/profiles/vinnie.png",
    name: "Vinnie Colaiuta",
    description: "Dispensa apresentações",
    rate: "5.0",
    ncomments: "12M",
    release: "Um dos bateristas mais respeitados da indústria.",
    lastJobs: "Colaborou com artistas de diversos gêneros musicais.",
  ),
];

final List<Gig> gigs = [
  Gig(
    image: "assets/profiles/kiko.png",
    name: "Kiko Loureiro",
    instrument: "Guitarrista",
    gigdescription: "Preciso de uma banda!",
    local: "Bunker, Rua Dr. Barata, Ribeira",
    cidade: "Natal/RN",
    date: "20-12-2023",
    hour: "20:30 - 23:30",
    cache: "150,00",
    musicianCategory: "Baixista, Tecladista, Baterista",
    gigdetails:
        "Show privado na casa de um aluno. Preciso que todos estejam lá as 20:15.",
  ),
  Gig(
    image: "assets/profiles/vinnie.png",
    name: "Vinnie Colaiuta",
    instrument: "Baterista",
    gigdescription: "Algum tecladista disponível?",
    local: "Curió, Rua Praia de Ponta Negra",
    cidade: "Natal/RN",
    date: "21-12-2023",
    hour: "20:30 - 23:30",
    musicianCategory: "Tecladista",
    cache: "80,00",
    gigdetails:
        "Show privado na casa de um aluno. Preciso que todos estejam lá as 20:15.",
  ),
  Gig(
    image: "assets/profiles/simon.png",
    name: "Simon Phillips",
    instrument: "Baterista",
    gigdescription: "Algum guitar pra fazer?",
    local: "Mahalila, R. Dra. Nívea Madruga",
    cidade: "Natal/RN",
    date: "22-12-2023",
    hour: "20:30 - 23:30",
    musicianCategory: "Guitarrista",
    cache: "170,00",
    gigdetails:
        "Show privado na casa de um aluno. Preciso que todos estejam lá as 20:15.",
  ),
  Gig(
    image: "assets/profiles/jr.png",
    name: "Junior Groovador",
    instrument: "Baixista",
    gigdescription: "Um cantor pra matar o frango!",
    local: "Só Mais Uma, Av. Engenheiro Roberto Freire, 8750",
    cidade: "Natal/RN",
    date: "23-12-2023",
    hour: "20:30 - 23:30",
    musicianCategory: "Cantor",
    cache: "120,00",
    gigdetails:
        "Show privado na casa de um aluno. Preciso que todos estejam lá as 20:15.",
  ),
  Gig(
    image: "assets/profiles/kiko.png",
    name: "Kiko Loureiro",
    instrument: "Guitarrista",
    gigdescription: "Preciso de um baterista!!!",
    local: "Bunker, Rua Dr. Barata, Ribeira",
    cidade: "Natal/RN",
    date: "24-12-2023",
    hour: "20:30 - 23:30",
    musicianCategory: "Baterista",
    cache: "150,00",
    gigdetails:
        "Show privado na casa de um aluno. Preciso que todos estejam lá as 20:15.",
  ),
  Gig(
    image: "assets/profiles/kiko.png",
    name: "Kiko Loureiro",
    instrument: "Guitarrista",
    gigdescription: "Preciso de uma banda!",
    local: "Bunker, Rua Dr. Barata, Ribeira",
    cidade: "Natal/RN",
    date: "20-12-2023",
    hour: "20:30 - 23:30",
    cache: "150,00",
    musicianCategory: "Baixista, Tecladista, Baterista",
    gigdetails:
        "Show privado na casa de um aluno. Preciso que todos estejam lá as 20:15.",
  ),
  Gig(
    image: "assets/profiles/vinnie.png",
    name: "Vinnie Colaiuta",
    instrument: "Baterista",
    gigdescription: "Algum tecladista disponível?",
    local: "Curió, Rua Praia de Ponta Negra",
    cidade: "Natal/RN",
    date: "21-12-2023",
    hour: "20:30 - 23:30",
    musicianCategory: "Tecladista",
    cache: "80,00",
    gigdetails:
        "Show privado na casa de um aluno. Preciso que todos estejam lá as 20:15.",
  ),
  Gig(
    image: "assets/profiles/simon.png",
    name: "Simon Phillips",
    instrument: "Baterista",
    gigdescription: "Algum guitar pra fazer?",
    local: "Mahalila, R. Dra. Nívea Madruga",
    cidade: "Natal/RN",
    date: "22-12-2023",
    hour: "20:30 - 23:30",
    musicianCategory: "Guitarrista",
    cache: "170,00",
    gigdetails:
        "Show privado na casa de um aluno. Preciso que todos estejam lá as 20:15.",
  ),
  Gig(
    image: "assets/profiles/jr.png",
    name: "Junior Groovador",
    instrument: "Baixista",
    gigdescription: "Um cantor pra matar o frango!",
    local: "Só Mais Uma, Av. Engenheiro Roberto Freire, 8750",
    cidade: "Natal/RN",
    date: "23-12-2023",
    hour: "20:30 - 23:30",
    cache: "120,00",
    gigdetails:
        "Show privado na casa de um aluno. Preciso que todos estejam lá as 20:15.",
  ),
  Gig(
    image: "assets/profiles/kiko.png",
    name: "Kiko Loureiro",
    instrument: "Guitarrista",
    gigdescription: "Preciso de um baterista!!!",
    local: "Bunker, Rua Dr. Barata, Ribeira",
    cidade: "Natal/RN",
    date: "24-12-2023",
    hour: "20:30 - 23:30",
    musicianCategory: "Baterista",
    cache: "150,00",
    gigdetails:
        "Show privado na casa de um aluno. Preciso que todos estejam lá as 20:15.",
  ),
];

class UserData {
  final String publicName;
  final String email;

  UserData({
    required this.publicName,
    required this.email,
  });
}
