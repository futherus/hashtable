#include <assert.h>

#include "../src/Hashtable.h"
#include "../utils/logs/logs.h"
#include "../src/hash.h"
#include "../utils/stats.h"
#include "../utils/text.h"

// staltic void print_ht_elem(FILE* stream, const ht_elem_t* elem)
// {
//     fprintf(stream, "%lu", *elem);
// }

static uint64_t hash_test(const void* data, size_t)
{
    const unsigned char* ptr = (const unsigned char*) data;
    uint64_t hash = ptr[0];

    for(size_t i = 1; i < KEY_SIZE; i++)
    {
        hash = ((hash >> 1) | (hash << 31)) ^ ptr[i];
    }

    return hash;
}

int main()
{
    logs_init("hash_test5.html");

    Hashtable ht = {};
    int err = hashtable_ctor(&ht, 256, &hash_test);
    if(err)
        return err;

    Text text = {};
    err = text_ctor(&text, "../tests/test_text.txt");
    if(err)
    {
        hashtable_dtor(&ht);
        return err;
    }

    // err = text_print(&text, "hash_test5_text.txt");
    // if(err)
    // {
    //     text_dtor(&text);
    //     hashtable_dtor(&ht);
    //     return err;
    // }

    LOG$("Words amount: %lu\n", text.index_arr_size);

    char buffer[KEY_SIZE] = {};

    for(size_t iter = 0; iter < text.index_arr_size; iter++)
    {
        size_t size = text.index_arr[iter].size;
        if(size > KEY_SIZE)
            size = KEY_SIZE;
        
        memcpy(buffer, text.index_arr[iter].begin, size);

        err = hashtable_insert(&ht, buffer, iter);
        if(err && err != HASHTABLE_ALREADY_INSERTED)
        {
            hashtable_dtor(&ht);
            text_dtor(&text);

            return err;
        }

        LOG$("Iteration: %lu, %d", iter, err);
        
        memset(buffer, 0, KEY_SIZE);
    }    

    err = 0;
    
    LOG$("Inserted");

    // FILE* stream = fopen("collisions5.csv", "w");
    // if(!stream)
    //     return 1;
    // stats_collisions(&ht, stream);
    // err = fclose(stream);

    LOG$("Destructors");
    hashtable_dtor(&ht);
    text_dtor(&text);

    return err;
}