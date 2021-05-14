//
//  ContentView.swift
//  bukowsky
//
//  Created by User1 on 14.05.21.
//

import SwiftUI

struct Cocktail : Decodable, Identifiable {
    var id: String {
        get {
            return idDrink
        }
    }
    var idDrink : String
    var strDrink : String
    var strDrinkThumb: String
    var strInstructionsDE: String
}

struct CocktailsList : Decodable {
    var drinks : [Cocktail] = [Cocktail]()
}

struct DetailsView: View {
    @State var cocktail : Cocktail
    var body: some View {
            VStack() {
                Text(cocktail.strDrink).font(.title3)
                AsyncImage(
                    url: URL(string: cocktail.strDrinkThumb )!,
                                placeholder: {Text("Loading...")},
                    image: {uiimage in Image(uiImage: uiimage).resizable().scaledToFit()}
                ).frame(height: 200)
                Text(cocktail.strInstructionsDE).padding()
            }
    }
}

struct ListView: View {
    @State var query : String = "vodka"
    @State var list = CocktailsList()
    @State var isError = false
    var body: some View {
        Text(query)
        VStack {
            List(list.drinks) { entry in
                ZStack {
                    HStack {
                        VStack(alignment: .leading) {
                            NavigationLink(destination: DetailsView(cocktail: entry))
                            {
                                Text(entry.strDrink)
                            }
                            
                        }
                    }
                }
                
            }.onAppear {
                list = loadCocktailsList()!
            }
        }
    }
    

    func loadCocktailsList() -> CocktailsList? {
        do {
            if let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/search.php?s=\(self.query)") {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                return try decoder.decode(CocktailsList.self, from: data)
            }
        } catch {
            fatalError("Couldn't fetch Drinks...\n\(error)")
            
        }
        return nil
    }
}
struct ContentView: View {
    @State var query: String = ""
    @State var showList = false
    var body: some View {
            VStack(){
                // Header
                Text("Welcome to the Bukowsky").font(.title)
                Text("it's five o'clock somewhere ...").font(.title2)
                // Main View
                NavigationView {
                    VStack() {
                        Image("Bukowsky").resizable().scaledToFit().clipShape(Circle())
                    
                        // Search for Cocktails
                        TextField("Search for a Cocktail", text: $query, onCommit: { showList = true }).padding().textFieldStyle(RoundedBorderTextFieldStyle())
                        NavigationLink(destination: ListView(query: self.query), isActive: $showList){ EmptyView()}
                    }
                }
                .navigationViewStyle(
                    StackNavigationViewStyle())
                // Footer
                Text("Made for ZHAW and fun by Philip Keller and Daniel Lerch").font(.footnote)
            }
            
        
        
        
    }

//    func loadRandomCocktail() -> RandomCocktail? {
//        do {
//            // request tha shit
//            if let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/random.php") {
//                // create data instance:
//                let data = try Data(contentsOf: url)
//                let decoder = JSONDecoder()
//                // decode it to url
//            return try decoder.decode(RandomCocktail.self, from:data)
//            }
//        } catch {
//            fatalError("Couldn't fetch Random Cocktail from API")
//        }
//        return nil
//    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
