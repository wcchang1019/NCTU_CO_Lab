#include <iostream>
#include <math.h>
#include <stdio.h>
#include <vector>

using namespace std;

const int K = 1024;
//const int associativity = 8;

struct cache_content{
	vector<bool> v;
	vector<unsigned int> tag;
	//unsigned int data[associativity];
};


void simulate(int cache_size, int block_size, int associativity){
	unsigned int tag,index,x;

	int offset_bit = (int) log2(block_size*associativity);
	int index_bit = (int) log2(cache_size/block_size*associativity);
	int line = (cache_size >> (offset_bit));
    int number_of_lines = 0;

	cache_content *cache = new cache_content[line];
	//cout << "cache line:" << line << endl;

	for(int j=0;j<line;j++){
        for(int k=0;k<associativity;k++){
            cache[j].v.push_back(false);
            cache[j].tag.push_back(0);
        }
	}


    FILE *infile=fopen("Trace.txt","r");	//read file
    int ch;
    while (EOF != (ch=getc(infile))){
        if ('\n' == ch)
            ++number_of_lines;
    }
    //cout << number_of_lines << endl;
    fclose(infile);
	int hit_line[number_of_lines];
	int miss_line[number_of_lines];
	for(int i=0;i<number_of_lines;i++){
        hit_line[i] = 0;
        miss_line[i] = 0;
	}
	int hit_count = 0;
	int miss_count = 0;

    FILE * fp=fopen("Trace.txt","r");	//read file
    int aa = 1;
	while(fscanf(fp,"%x",&x)!=EOF){
		//cout << hex << x << " ";
		index = (x >> offset_bit) & (line - 1);
		tag = x >> (index_bit + offset_bit);
		bool hit = false;
		for(int i=0;i<associativity;i++){
            if(cache[index].v[i] && cache[index].tag[i] == tag){
                for(int x=0;x<i;x++){
                    cache[index].v[x+1] = cache[index].v[x];
                    cache[index].tag[x+1] = cache[index].tag[x];
                }
                cache[index].v[0] = true;
                cache[index].tag[0] = tag;
                hit = true;
                hit_line[hit_count] = aa;    //hit
                hit_count++;
                break;
            }
		}
		if(!hit){
            bool confirm_miss = false;
            for(int i=0;i<associativity;i++){
                if(cache[index].tag[i] == -1){
                    cache[index].v[i]=true;			//miss
                    cache[index].tag[i]=tag;
                    confirm_miss = true;
                }
            }
            if(!confirm_miss){
                cache[index].v[associativity-1]=true;			//miss
                cache[index].tag[associativity-1]=tag;
                confirm_miss = true;
            }
			miss_line[miss_count] = aa;
			miss_count++;
		}


		/*if(cache[index].v && cache[index].tag == tag){
			cache[index].v=true;
			hit_line[hit_count] = aa;    //hit
			hit_count++;
		}
		else{
			cache[index].v=true;			//miss
			cache[index].tag=tag;
			miss_line[miss_count] = aa;
			miss_count++;
		}*/
		aa++;
	}
	fclose(fp);

	cout << "Hits instructions:" ;
    for(int i=0;i<hit_count;i++)
        if(i != hit_count-1)
            cout << hit_line[i] << ",";
        else
            cout << hit_line[i] << endl;

    cout << "Misses instructions:";
    for(int i=0;i<miss_count;i++)
        if(i != miss_count-1)
            cout << miss_line[i] << ",";
        else
            cout << miss_line[i] << endl;

    cout << "Miss rate:" << miss_count*100/number_of_lines << "%" << endl;

	delete [] cache;
}

int main(){
	// Let us simulate 4KB cache with 16B blocks
	int block_size, cache_size, associativity;
    cout << "Cache Size(B):";
	cin >> cache_size;
	cout << "Block Size(B):";
	cin >> block_size;
	cout << "Associativity:";
	cin >> associativity;
	simulate(cache_size, block_size, associativity);
}
