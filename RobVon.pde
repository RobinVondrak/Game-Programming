class RobVon implements WalkerInterface
{
  IntList moveQueue = new IntList();
  PVector position = new PVector();
  boolean resetQueue = false;
  int playWidth;
  int playHeight;
  int minWidth = 10;
  int minHeight = 5;
  //Walker pattern
  int patternX = 5;
  int patternXmin = 3;
  int patternXmax = 6;

  int patternY = 15;
  int patternYmin = 3;
  int patternYmax = 15;

  int upDown;
  int leftRight;

  String getName()
  {
    return "Shrock";
  }

  PVector getStartPosition(int playAreaWidth, int playAreaHeight)
  {
    position = new PVector();

    playWidth = playAreaWidth - minWidth;
    playHeight = playAreaHeight - minHeight;

    position.x = (int) random(minWidth, playWidth * 0.15);
    switch ((int)random(0, 2))
    {
      case 0:
      position.x = (int) random(minWidth, playWidth * 0.15);
      break;
      default:
      position.x = (int) random(playWidth - minWidth, (playWidth - minWidth) + playWidth * 0.1);
      break;
    }
    position.y = (int) random(minHeight, playHeight);

    //0 = left, 1 = right, 2 = down, 3 = up
    upDown = (int)random(2, 4);
    leftRight = (int)random(0, 2);
    return position;
  }

  PVector update()
  {
    PVector movement = new PVector();
    if (moveQueue.size() > 0)
    {
      movement = MoveWalker(moveQueue.get(0)); //Kanske måste köra reverse?
      GetNextMove(movement);
      if(!resetQueue)
        moveQueue.remove(0);
    }
    else
    {
      if (random(0, 1010) <= random(0, 175))
        GetMovePattern();

      movement = MoveWalker((int)random(0, 4));
      movement = AllowedMove(movement);
      GetNextMove(movement); 
    }

    position.add(movement);
    return movement;
  }

  void GetMovePattern()
  {
    //To get odd number
    patternY = ((int)random(patternYmin, patternYmax)) / 2;
    patternY *= 2;
    patternY++;

    patternX = (int)random(patternXmin, patternXmax);
  //0 = left, 1 = right, 2 = down, 3 = up
  for (int i = 0; i < patternY; ++i)
  {
    moveQueue.append(upDown);
    for (int j = 0; j < patternX; ++j)
    {
      moveQueue.append(leftRight);
    } 
    leftRight++;
    leftRight &= 1;
  }
  leftRight++;
  leftRight &= 1;
}

PVector AllowedMove(PVector movement)
{
  if (movement.y != 0)
  {
    movement = MoveWalker(upDown);
  }
  return movement;
}

void GetNextMove(PVector movement)
{
  resetQueue = false;

  if ((position.x + movement.x) > playWidth)
  {
    leftRight = 0;
    movement.x = -1;
    resetQueue = true;
  }
  else if ((position.x + movement.x) < minWidth)
  {
    leftRight = 1;
    movement.x = 1;
    resetQueue = true;
  }

  if ((position.y + movement.y) > playHeight)
  {
    upDown = 3; // 2 = down
    movement.y = -1;
    resetQueue = true;
  }
  else if ((position.y + movement.y) < minHeight)
  {
    upDown = 2; // 3 = up
    movement.y = 1;
    resetQueue = true;
  }

  if (resetQueue)
  {
    moveQueue.clear();
    println(moveQueue.size());
  }
}

PVector MoveWalker(int move)
{
  switch(move)
  {
    case 0:
    return new PVector(-1, 0);
    case 1:
    return new PVector(1, 0);
    case 2:
    return new PVector(0, 1);
    default:
    return new PVector(0, -1);
  }
}
}