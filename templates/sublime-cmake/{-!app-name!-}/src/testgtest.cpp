#include "gtest/gtest.h"

TEST(SquareRootTest, PositiveNos) { 
    EXPECT_EQ (18.0, 18.0);
    EXPECT_EQ (25.4, 25.4);
    EXPECT_EQ (50.3321, 50.3321);
}

TEST (SquareRootTest, ZeroAndNegativeNos) { 
    ASSERT_EQ (0.0, 0.0);
    ASSERT_EQ (-1, -1);
}

int main(int argc, char **argv) {
  ::testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
