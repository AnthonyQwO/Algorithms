import SwiftUI
import UIKit

struct AlgorithmInfo {
    let name: String
    let introduction: String
    let code: String
    let bio: String
    let icon: String
    let timeComplexity: String
    let spaceComplexity: String
    let images: Array<UIImage>    
    
    init(name: String = "Title", introduction: String = "context", code: String = "printf(\"Hello World!\");", bio: String = "short bio", icon: String = "pencil.circle", timeComplexity: String = "None", spaceComplexity: String = "None", images: Array<UIImage> = []) {
        self.name = name
        self.introduction = introduction
        self.code = code
        self.bio = bio
        self.icon = icon
        self.timeComplexity = timeComplexity
        self.spaceComplexity = spaceComplexity
        self.images = images
    }
}

struct ContentView: View {
    let stringAlgorithm = [
        AlgorithmInfo(
            name: "Hash",
            introduction: 
        """
        哈希算法在解決許多問題上非常有幫助。
        
        我們想要有效地解決比較字符串的問題。暴力的解決方法只是比較兩個字符串的字母，如果 x 和 y 是兩個字符串的大小，這樣的做法的時間複雜度是 O(min(x, y))。我們希望能做得更好。字符串哈希的基本思想如下：我們將每個字符串映射為一個整數，然後比較這些整數，而不是字符串。這樣可以將字符串比較的執行時間減少到 O(1)。
        
        為了進行轉換，我們需要一個所謂的哈希函數。它的目標是將字符串轉換為整數，即字符串的哈希值。必須滿足以下條件：如果兩個字符串 s 和 t 相等（s = t），那麼它們的哈希值也必須相等（hash(s) = hash(t)）。否則，我們將無法比較字符串。
        
        請注意，反向條件不必成立。如果哈希值相等（hash(s) = hash(t)），那麼這兩個字符串不一定要相等。例如，一個有效的哈希函數可以是對每個 s 都是 hash(s) = 0。這只是個愚蠢的例子，因為這個函數將完全無用，但它仍然是一個有效的哈希函數。反向條件不必成立的原因是，存在指數量級的字符串。如果我們只希望這個哈希函數能夠區分所有由小寫字符組成且長度小於 15 的字符串，那麼哈希值就無法再適合 64 位整數（例如無符號長整數）了，因為有太多這樣的字符串。當然，我們也不想比較任意長的整數，因為這樣的比較時間複雜度仍然是 O(n)。
        
        所以通常我們希望哈希函數將字符串映射到固定範圍的數字 [0, m)，這樣比較字符串就只是比較兩個固定長度的整數。而且，當 s ≠ t 時，我們希望 hash(s) ≠ hash(t) 是非常可能的。
        
        這是你必須記住的重要部分。使用哈希不會 100% 確定正確，因為兩個完全不同的字符串可能具有相同的哈希值（哈希碰撞）。然而，在絕大多數任務中，這可以安全忽略，因為兩個不同字符串的哈希碰撞的概率仍然非常小。在本文中，我們將討論一些技術，以保持碰撞的概率非常低。
        
        """,
            code: 
        """
        // 1-base
        // H[R] - H[L-1] * p^(R-L+1)
        // cmp的+modl是為了防止負數
        const int p = 75577, modl = 1e9 + 7;
        vector<int> build(const string& s) {
            vector<int> ret(1, 0);
            for(int i = 1; i <= s.size(); i++)
                ret.push_back((ret.back() * p % modl + s[i - 1]) % modl);
            return ret;
        }
        int qpow(int n, int k) {
            int ret = 1;
            for(; k; k >>= 1, n = n * n % modl) if(k & 1) ret = ret * n % modl;
            return ret;
        }
        bool cmp(const vector<int>& h, int i, int len, int Hash) {
            return (h[i + len - 1] - h[i - 1] * qpow(p, len) % modl + modl) % modl == Hash;
        }
        """,
            bio: "String Hashing 是一種將字串轉換為數字的技術。",
            icon: "textformat",
            timeComplexity: "O(n)",
            spaceComplexity: "O(n)"
        ),
        AlgorithmInfo(
            name: "KMP",
            introduction: 
        """
        KMP演算法可在一個字串S內尋找一個字W的出現位置。一個詞在不匹配時本身就包含足夠的資訊來確定下一個匹配可能的開始位置，此演算法利用這一特性以避免重新檢查先前配對的字元。
        """,
            code: 
        """
        /* len-failure[k]:
        在k結尾的情況下，這個子字串可以由開頭
        長度為(len-failure[k])的部分重複出現來表達
        
        failure[k]為次長相同前綴後綴
        如果我們不只想求最多，而且以0-base做為考量
        ，那可能的長度由大到小會是
        failuer[k]、failure[failuer[k]-1]
        、failure[failure[failuer[k]-1]-1]..
        直到有值為0為止 */
        int failure[MXN];
        vector<int> KMP(string& t, string& p) {
            vector<int> ret;
            if(p.size() > t.size()) return ret;
            for(int i = 1, j = failure[0] = -1; i < p.size(); i++) {
                while(j >= 0 && p[j + 1] != p[i]) j = failure[j];
                if(p[j + 1] == p[i]) j++;
                failure[i] = j;
            }
            for(int i = 0, j = -1; i < t.size(); i++) {
                while (j >= 0 && p[j + 1] != t[i]) j = failure[j];
                if(p[j + 1] == t[i]) j++;
                if(j == p.size() - 1) {
                    ret.push_back(i - p.size() + 1);
                    j = failure[j];
                }   
            }   
            return ret;
        }
        """,
            bio: "KMP演算法可在一個字串S內尋找一個字W的出現位置",
            icon: "book.pages",
            timeComplexity: "O(n)",
            spaceComplexity: "O(n)",
            images: [UIImage(imageLiteralResourceName: "KMP0")]
        ),
        AlgorithmInfo()
    ]
    
    let datastructureAlgorithm = [
        AlgorithmInfo(
            name: "BIT",
            introduction: 
        """
        二進位索引樹（Binary Indexed Tree, BIT），也稱為Fenwick Tree，是一種有效的資料結構，用於解決區間查詢和更新問題。它特別適用於處理一維數組的前綴和計算，能夠在對數時間內完成更新和查詢操作。
        """,
            code: 
        """
        #define lowbit(x) (x&-x)
        struct BIT {
            int n;
            vector<int> bit;
            BIT(int _n):n(_n), bit(n + 1) {}
            void update(int x, int val) {
                for(; x <= n; x += lowbit(x)) bit[x] += val;
            }
            void update(int L, int R, int val) {
                update(L, val), update(R + 1, -val);        
            }
            int query(int x) {
                int res = 0;
                for(; x; x -= lowbit(x)) res += bit[x];
                return res;
            }
            int query(int L, int R) {
                return query(R) - query(L - 1);
            }
        };
        """,
            bio: "BIT特別適用於處理一維數組的前綴和計算，能夠在對數時間內完成更新和查詢操作",
            icon: "tray.2",
            timeComplexity: "O(lg(n))",
            spaceComplexity: "O(n)",
            images: [UIImage(imageLiteralResourceName: "BIT0"), UIImage(imageLiteralResourceName: "BIT1")]
        ),
        AlgorithmInfo(
            name: "DSU",
            introduction: 
        """
        在電腦科學中，併查集是一種資料結構，用於處理一些不交集的合併及查詢問題。併查集支援如下操作： 查詢：查詢某個元素屬於哪個集合，通常是返回集合內的一個「代表元素」。這個操作是為了判斷兩個元素是否在同一個集合之中。 合併：將兩個集合合併為一個。
        """,
            code: 
        """
        struct DSU { // 並查集
            vector<int> fa, sz;
            DSU(int n = 0) : fa(n), sz(n, 1) {
                iota(fa.begin(), fa.end(), 0);
            }
            int Find(int x) { // 路徑壓縮
                while (x != fa[x])
                    x = fa[x] = fa[fa[x]];
                return x;
            }
            bool Merge(int x, int y) { //合併
                x = Find(x), y = Find(y);
                if (x == y) return false; // 是否為連通
                if (sz[x] > sz[y]) swap(x, y);
                fa[x] = y;
                sz[y] += sz[x];
                return true;
            }
        };
        """,
            bio: "併查集是一種資料結構，用於處理一些不交集的合併及查詢問題",
            icon: "personalhotspot",
            timeComplexity: "O(1)",
            spaceComplexity: "O(n)"
            // images: [Image("bit0"), Image("bit1")]
        )
    ]
    
    let graphAlgorithm = [
        AlgorithmInfo(
            name: "Floryd Warshall",
            introduction: 
        """
        Floyd-Warshall演算法，中文亦稱弗洛伊德演算法或佛洛依德演算法，是解決任意兩點間的最短路徑的一種演算法，可以正確處理有向圖或負權的最短路徑問題，同時也被用於計算有向圖的遞移閉包。 
        """,
            code: 
        """
        for( int k=0 ; k < n ; k++ )
            for( int i=0 ; i < n ; i++ )
                for( int j=0 ; j < n ; j++ )
                    if( dis[i][j] > dis[i][k]+dis[k][j] && dis[i][k] < INF && dis[k][j] < INF )
                    dis[i][j]=dis[i][k]+dis[k][j];
        """,
            bio: "解決任意兩點間的最短路徑的一種演算法",
            icon: "map",
            timeComplexity: "O(n^3)",
            spaceComplexity: "O(n^2)",
            images: [UIImage(imageLiteralResourceName: "floydwarshall0")]
        )
    ]
    
    let columns = [
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("String Algorithms")
                        .font(.title)
                        .padding()
                        .bold()
                    
                    // 水平 ScrollView
                    ScrollView(.horizontal) {
                        LazyHGrid(rows: columns, spacing: 20) { // 使用 LazyHGrid 而不是 LazyVGrid 來橫向排列
                            ForEach(stringAlgorithm, id: \.name) { algorithm in
                                NavigationLink(destination: NewView(algorithm: algorithm)) {
                                    VStack(alignment: .leading, spacing: 30) {
                                        Image(systemName: algorithm.icon)
                                        Text(algorithm.name)
                                    }
                                    .padding()
                                    .frame(width: 150, height: 100, alignment: .leading)
                                    .background(.ultraThinMaterial)
                                    .background(.orange)
                                    .cornerRadius(25)
                                    .foregroundColor(.white)
                                    .contextMenu {
                                        Text(algorithm.bio)
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }
                .padding()
                
                VStack(alignment: .leading) {
                    Text("Datastructures")
                        .font(.title)
                        .padding()
                        .bold()
                    
                    // 水平 ScrollView
                    ScrollView(.horizontal) {
                        LazyHGrid(rows: columns, spacing: 20) { // 使用 LazyHGrid 而不是 LazyVGrid 來橫向排列
                            ForEach(datastructureAlgorithm, id: \.name) { algorithm in
                                NavigationLink(destination: NewView(algorithm: algorithm)) {
                                    VStack(alignment: .leading, spacing: 30) {
                                        Image(systemName: algorithm.icon)
                                        Text(algorithm.name)
                                    }
                                    .padding()
                                    .frame(width: 150, height: 100, alignment: .leading)
                                    .background(.ultraThinMaterial)
                                    .background(.blue)
                                    .cornerRadius(25)
                                    .foregroundColor(.white)
                                    .contextMenu {
                                        Text(algorithm.bio)
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }
                .padding()
                
                VStack(alignment: .leading) {
                    Text("Graph Algorithms")
                        .font(.title)
                        .padding()
                        .bold()
                    
                    // 水平 ScrollView
                    ScrollView(.horizontal) {
                        LazyHGrid(rows: columns, spacing: 20) { // 使用 LazyHGrid 而不是 LazyVGrid 來橫向排列
                            ForEach(graphAlgorithm, id: \.name) { algorithm in
                                NavigationLink(destination: NewView(algorithm: algorithm)) {
                                    VStack(alignment: .leading, spacing: 30) {
                                        Image(systemName: algorithm.icon)
                                        Text(algorithm.name)
                                    }
                                    .padding()
                                    .frame(width: 150, height: 100, alignment: .leading)
                                    .background(.ultraThinMaterial)
                                    .background(.red)
                                    .cornerRadius(25)
                                    .foregroundColor(.white)
                                    .contextMenu {
                                        Text(algorithm.bio)
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }
                .padding()
            }
            .navigationTitle("Algorithms")
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
    }
}

#Preview {
    ContentView()
}
